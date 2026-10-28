#!/bin/bash

# License: Apache 2.0 without attribution need.

# The --install steps of Fil-C-Light's build.sh, which sources this file: where a
# toolchain installs, getting root for it, the installer package of a --musl or --cosmo
# toolchain, and installing through that package.
#
# The functions read build.sh's settings (`INSTALL`, `INSTALL_DIR`, `LIBC`, `ARCH`, `ARCHS`,
# `CROSS`, `HEADLESS`, `NO_SUDO`, `TOOLS`, `DIST`, `PUBLISH`, ...). A step that needs root runs
# through `filc_install_run`: with sudo, or, under --no-sudo (and --headless with no root
# at hand), not at all; its command is then logged for the user to run as root.

# Lets the installer package find its setup.sh template (optfil-setup.sh.in) beside
# this file, wherever build.sh runs from.
FILC_AUTOMATION="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tells whether installing at `INSTALL_DIR` needs root: the folder, or the nearest one above
# it that exists, is not writable.
filc_install_needs_root() {
  local dir="${INSTALL_DIR:-/opt/fil}"
  while [ ! -e "$dir" ]; do dir="$(dirname "$dir")"; done
  [ ! -w "$dir" ]
}

# Runs <command> to install at `INSTALL_DIR`: as root when that needs root. Under
# --no-sudo it runs nothing that needs root, and logs the command instead (see
# `filc_install_log_step`).
filc_install_run() {
  if ! filc_install_needs_root; then
    "$@"
  elif [ -z "${NO_SUDO:-}" ]; then
    sudo "$@"
  else
    filc_install_log_step "$@"
  fi
}

# Names the log of the steps that needed root and were skipped this run (see
# `filc_install_log_step`); a shell script that runs each of them with sudo.
filc_install_steps_log() {
  echo "${FILC_ROOT_STEPS:-$TOOLS/root-steps.sh}"
}

# Logs <command>, which needs root, as a line of the steps log (see
# `filc_install_steps_log`), and says so. The list that `--files-from=-` reads from stdin
# is saved beside the log, and the logged line names that file instead.
filc_install_log_step() {
  local log arg list
  local -a cmd=()
  log="$(filc_install_steps_log)"
  mkdir -p "$(dirname "$log")"
  if [ ! -s "$log" ]; then
    printf '#!/bin/sh\n# The steps of a Fil-C-Light run that need root, skipped by --no-sudo or\n# --headless; run this file to do them.\nset -e\n' > "$log"
  fi
  for arg in "$@"; do
    if [ "$arg" = --files-from=- ]; then
      list="${log%.sh}-$(grep -c '^sudo ' "$log").list"
      cat > "$list"
      arg="--files-from=$list"
    fi
    cmd+=("$arg")
  done
  {
    printf 'sudo'
    printf ' %q' "${cmd[@]}"
    printf '\n'
  } >> "$log"
  echo "(needs root, hence skipped; logged in $log: sudo ${cmd[*]})"
}

# Tells whether this run skipped a step that needs root (see `filc_install_run`).
filc_install_skipped() {
  [ -n "${NO_SUDO:-}" ] && grep -q '^sudo ' "$(filc_install_steps_log)" 2>/dev/null
}

# Tells whether this run installs any toolchain: --install, and an arch that runs on this
# machine among `ARCHS`, or any arch with --install=<dir> (see `filc_install_wanted`).
filc_install_any() {
  [ "${INSTALL:-0}" = 1 ] || return 1
  filc_install_custom && return 0
  case " $ARCHS " in *" $(filc_host_arch) "*) return 0 ;; esac
  return 1
}

# Tells whether --install=<dir> named another folder than /opt/fil.
filc_install_custom() {
  [ "${INSTALL_DIR:-/opt/fil}" != /opt/fil ]
}

# Tells whether this run installs the toolchain of the current arch (see `filc_use_arch`):
# `filc_install_any`, with that arch alone in `ARCHS`.
filc_install_wanted() {
  local ARCHS="${ARCH:-$(filc_host_arch)}"
  filc_install_any
}

# Picks the folder a --musl or --cosmo toolchain installs at when --install named none:
# /opt/fil, which the glibc toolchain uses too, unless the user answers "no" to sharing
# it; then /opt/fil-<libc>. An empty answer asks again, on the same line. With nobody to
# ask (--headless, or no input left), it takes /opt/fil-<libc>.
filc_install_pick_dir() {
  local answer=""
  if [ "${LIBC:-glibc}" = glibc ] || [ "${INSTALL:-0}" != 1 ] || filc_install_custom; then
    return 0
  fi
  if [ -z "$HEADLESS" ]; then
    while [ -z "$answer" ]; do
      printf 'Do you want to install at /opt/fil which glibc builds use? [y/n] '
      read -r answer || { echo; answer=no; break; }
      # Ignores case and whitespace.
      answer="$(printf '%s' "$answer" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
      # Removes the empty line that Enter left on a terminal, for the question to show
      # again where it was.
      if [ -z "$answer" ] && [ -t 0 ] && [ -t 1 ]; then
        printf '\033[A\r\033[K'
      fi
    done
    case "$answer" in
      n|no) ;;
      *) return 0 ;;
    esac
  fi
  INSTALL_DIR="/opt/fil-$LIBC"
  echo "The $LIBC toolchain installs at $INSTALL_DIR."
}

# Gets root for --install (sudo) at the start of the run, as the steps that need it come
# hours later, and keeps sudo's timestamp fresh until the run ends (`FILC_SUDO_KEEPALIVE`):
# the EXIT trap of `filc_main` ends that loop, and the loop also ends by itself once this
# run's shell is gone, hence it never outlives the run.
#
# Under --no-sudo, and under --headless with no root at hand, it asks nothing: it warns
# that those steps are skipped and logged (see `filc_install_run`), and starts their log
# afresh.
filc_optfil_root() {
  # A folder that this user can write needs no root.
  filc_install_needs_root || return 0
  local reason=--no-sudo
  if [ -z "${NO_SUDO:-}" ] && [ -n "$HEADLESS" ] && ! sudo -n true 2>/dev/null; then
    NO_SUDO=1
    reason="--headless, with no root password at hand"
  fi
  if [ -n "${NO_SUDO:-}" ]; then
    mkdir -p "$(dirname "$(filc_install_steps_log)")"
    : > "$(filc_install_steps_log)"
    filc_warning "No root ($reason):" \
      "the steps that install the $LIBC toolchain at $INSTALL_DIR are skipped," \
      "and their commands logged in $(filc_install_steps_log) to run as root later."
    return 0
  fi
  if [ -z "$HEADLESS" ]; then
    echo "Root (sudo) is required for later steps: installing the toolchain at $INSTALL_DIR."
    echo "(pass --no-sudo or --headless to skip those steps and log their commands)"
    sudo -v || { echo "ERROR: no root, so the toolchain cannot be installed at $INSTALL_DIR." >&2; exit 1; }
  fi
  local run=$$
  ( while sleep 60; do
      kill -0 "$run" 2>/dev/null || exit 0
      sudo -n true 2>/dev/null || exit 0
    done ) &
  FILC_SUDO_KEEPALIVE=$!
}

# Warns at the end of a run that skipped steps that need root (see `filc_install_run`),
# naming the log that does them.
filc_install_report_skipped() {
  filc_install_skipped || return 0
  filc_warning "Steps that need root were skipped (--no-sudo or --headless); to do them, run:" \
    "sh $(filc_install_steps_log)"
}

# Prints the name of the installer package (without .xz) of the relocatable --musl or
# --cosmo package <name>: optfil-<libc>-<version>-linux-<arch>, from
# filc-<version>-linux-<arch>.xz or cosmo-filc-<version>-linux-<arch>.xz.
filc_installer_name() {   # $1 = relocatable package name
  local name="${1##*/}"
  name="${name%.xz}"
  case "$name" in
    cosmo-filc-*) echo "optfil-cosmo-${name#cosmo-filc-}" ;;
    *)            echo "optfil-musl-${name#filc-}" ;;
  esac
}

# Lays out, in <out dir>, the installer of the relocatable --musl or --cosmo package
# <path>, in the folder `filc_installer_name` names: the toolchain as fil.tar.xz, its
# licenses and README, and a setup.sh made from optfil-setup.sh.in, which installs it at
# /opt/fil-<libc> the way optfil-<version>-linux-<arch>.xz installs glibc's at /opt/fil.
filc_installer_pack() {   # $1 = relocatable package path, $2 = out dir
  local name libc ver work top
  name="$(filc_installer_name "$1")"
  libc="${name#optfil-}"
  libc="${libc%%-*}"
  ver="${name#optfil-"$libc"-}"
  ver="${ver%%-linux-*}"
  work="$2/.unpack-$name"
  rm -rf "$work" "${2:?}/$name"
  mkdir -p "$work" "$2/$name"
  tar -C "$work" -xJf "$1" || { rm -rf "$work"; return 1; }
  top="$(find "$work" -mindepth 1 -maxdepth 1 -type d | head -1)"
  if [ ! -f "$top/setup.sh" ]; then
    echo "ERROR: ${1##*/} holds no toolchain with its setup.sh" >&2
    rm -rf "$work"
    return 1
  fi
  mv "$top" "$work/fil"
  tar -C "$work" -cJf "$2/$name/fil.tar.xz" fil || { rm -rf "$work"; return 1; }
  cp "$work/fil/"*LICENSE* "$work/fil/README.md" "$2/$name/" 2>/dev/null || true
  sed -e "s/@LIBC@/$libc/g" -e "s/@VERSION@/$ver/g" "$FILC_AUTOMATION/optfil-setup.sh.in" \
    > "$2/$name/setup.sh"
  chmod +x "$2/$name/setup.sh"
  rm -rf "$work"
}

# Packs the relocatable package <name> of `DIST` (see `filc_upstream_package`) again as its
# installer package, `DIST`/optfil-<libc>-<version>-linux-<arch>.xz (see
# `filc_installer_pack`), and publishes it with --publish. /opt/fil is glibc's; hence its
# installer installs there only when asked to (--share-opt-fil).
filc_upstream_installer_package() {   # $1 = relocatable package name, $2 = marker file
  local name stage="$TOOLS/installer-$ARCH"
  name="$(filc_installer_name "$1")"
  rm -rf "$stage"
  filc_installer_pack "$DIST/$1" "$stage" || { rm -rf "$stage"; exit 1; }
  tar -C "$stage" -cJf "$DIST/$name.xz" "$name" || { rm -rf "$stage"; exit 1; }
  rm -rf "$stage"
  echo "archive: $DIST/$name.xz ($(du -h "$DIST/$name.xz" | cut -f1))"
  filc_check_archive "$name.xz" "$2" || exit 1
  [ "$PUBLISH" != 1 ] || filc_upload_archive "$name.xz"
}

# Installs the --musl or --cosmo toolchain of the current arch at `INSTALL_DIR` through
# its installer package: this run's one (packed now, with the relocatable package, when
# the run packed none; see `filc_upstream_package`), or the package <path>. The package is
# unpacked with no root into a stage, then its setup.sh runs (see `filc_installer_run`).
filc_upstream_install() {   # $1 = marker file of the run's start, [$2 = package path]
  local made="${2:-}" stage="$TOOLS/install-$ARCH" dir
  if [ -z "$made" ]; then
    made="$(find "$DIST" -maxdepth 1 -name "optfil-$LIBC-*-linux-$ARCH.xz" -newer "$1" 2>/dev/null \
              | head -1)"
  fi
  if [ -z "$made" ]; then
    filc_upstream_package "$1"
    made="$(ls -t "$DIST"/optfil-"$LIBC"-*-linux-"$ARCH".xz 2>/dev/null | head -1 || true)"
  fi
  rm -rf "$stage"
  mkdir -p "$stage"
  dir="$stage/$(basename "${made:-none}" .xz)"
  if ! tar -C "$stage" -xJf "$made" 2>/dev/null || [ ! -f "$dir/setup.sh" ]; then
    echo "ERROR: ${made:-no installer package} holds no installer with its setup.sh;" \
         "$INSTALL_DIR is left as it is." >&2
    rm -rf "$stage"
    exit 1
  fi
  filc_installer_run "$dir"
}

# Runs the setup.sh of the installer in <dir> (see `filc_installer_pack`) to install at
# `INSTALL_DIR`, as root when that needs root, then checks that the installed clang runs
# (a foreign arch's clang cannot run here). Under --no-sudo the command is logged
# instead (see `filc_install_run`), and <dir> stays for it to run later.
filc_installer_run() {   # $1 = installer dir
  local -a opts=(--prefix="$INSTALL_DIR" --unattended)
  [ "${INSTALL_DIR%/}" != /opt/fil ] || opts+=(--share-opt-fil)
  echo "===== $LIBC: installing the $ARCH toolchain at $INSTALL_DIR ====="
  if filc_install_needs_root && [ -n "${NO_SUDO:-}" ]; then
    filc_install_run sh "$1/setup.sh" "${opts[@]}"
    echo "(its installer stays in $1 for that step)"
    return 0
  fi
  mkdir -p "$TOOLS"
  filc_install_run sh "$1/setup.sh" "${opts[@]}" > "$TOOLS/setup-$ARCH.log" 2>&1 \
    || { echo "ERROR: setup.sh failed for $INSTALL_DIR; see $TOOLS/setup-$ARCH.log" >&2; exit 1; }
  # Removes the installer, then its stage once that is empty.
  rm -rf -- "$1"
  rmdir -- "$(dirname "$1")" 2>/dev/null || true
  if [ -n "$CROSS" ]; then
    echo "$ARCH toolchain installed at $INSTALL_DIR (its clang does not run here)."
  elif ! "$INSTALL_DIR/build/bin/clang" --version > /dev/null 2>&1; then
    echo "ERROR: the clang installed at $INSTALL_DIR does not run." >&2
    exit 1
  else
    echo "Toolchain ready at $INSTALL_DIR: $("$INSTALL_DIR/build/bin/clang" --version | head -1)"
  fi
}

# --no-build with --install, for a --musl or --cosmo toolchain: fetches the published
# installer package of the current arch (optfil-<libc>-<version>-linux-<arch>.xz, as
# `filc_upstream_installer_package` names it) and installs through it (see
# `filc_upstream_install`). A release with only the relocatable package
# (filc-<version>-linux-<arch>.xz, or cosmo-filc-... for cosmo) gets that one, and its
# installer is laid out here first (see `filc_installer_pack`).
filc_download_upstream_install() {
  local relocatable installer stage="$TOOLS/install-$ARCH"
  case "$LIBC" in
    cosmo) relocatable="cosmo-filc-$(filc_upstream_version)-linux-$ARCH.xz" ;;
    *)     relocatable="filc-$(filc_upstream_version)-linux-$ARCH.xz" ;;
  esac
  installer="$(filc_installer_name "$relocatable").xz"
  if filc_fetch_asset "$installer"; then
    filc_upstream_install "" "$TOOLS/$installer"
    rm -f "$TOOLS/$installer"
    return 0
  fi
  if ! filc_fetch_asset "$relocatable"; then
    echo "ERROR: no prebuilt $LIBC package $installer (nor $relocatable) is published;" \
         "build it: ./build.sh --$LIBC" >&2
    return 1
  fi
  rm -rf "$stage"
  filc_installer_pack "$TOOLS/$relocatable" "$stage" || { rm -f "$TOOLS/$relocatable"; return 1; }
  rm -f "$TOOLS/$relocatable"
  filc_installer_run "$stage/${installer%.xz}"
}
