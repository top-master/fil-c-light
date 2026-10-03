#!/usr/bin/env bash
#
# Fil-C-Light build driver.
#
# The expensive part of a Fil-C build is compiling LLVM+Clang from source (hours). To
# spare that, this driver defaults to building only this tree's own parts (the runtime
# and libc layers) with a prebuilt clang, and builds the clang from source on request
# (or when no prebuilt one is available).
#
#   ./build.sh                 Build this tree: fetch + unpack the prebuilt toolchain for
#                              this platform (build/ = the Fil-C clang of the compiler/
#                              repo, pizfix/ = runtime + libc + libc++), then build the
#                              runtime and the glibc slice with its clang, and sync them
#                              into the tree once they all built. A build folder whose
#                              clang was built from source keeps (and syncs) that clang
#                              instead of fetching one. Builds as --nightly if no
#                              matching archive can be downloaded.
#
#   ./build.sh --nightly       Build EVERYTHING FROM SOURCE: init the compiler/ submodule
#   ./build.sh --latest        (llvm+clang) if needed, compile clang, then the memory-safe
#                              runtime and the glibc slice. On success the result is packed
#                              as upstream packs it, for reuse/redistribution: glibc as the
#                              /opt/fil package dist/optfil-<version>-linux-<arch>.xz,
#                              musl as dist/filc-<version>-linux-<arch>.xz.
#
#                              Either build runs in the build folder beside this tree
#                              (../build/<tree name>, see -d), a mirror of the tree that
#                              upstream's scripts build in unchanged. The tree's own
#                              build/ and pizfix/ (the toolchain in use) are updated once
#                              the ENTIRE build is done (see --sync and --no-sync).
#
#   ./build.sh --no-build      Only fetch the prebuilt toolchain, building nothing (the
#                              result of a build, without one): installed at /opt/fil in
#                              its flat layout (upstream's setup.sh, as root), or with
#                              --no-install (or --headless with no root at hand) unpacked
#                              into the tree as build/ + pizfix/.
#
#   ./build.sh --universal     The UNIVERSAL toolchain, with any of the modes above: a
#   ./build.sh --static        clang linked portably (static libstdc++/libgcc; glibc stays
#   ./build.sh --general       dynamic, and is backward compatible) so it runs on any Linux
#                              whose glibc is at least as new as the build host's symbols
#                              need; the runtime in pizfix/ brings its own libc, so it never
#                              depends on the host's. With --nightly, an existing clang
#                              build is only re-linked; the runtime's portions are kept
#                              when their sources did not change, as in any build. Package
#                              names stay upstream's.
#   ./build.sh --no-universal  The distribution's toolchain (the default): a clang linked
#   ./build.sh --no-static     with the host's libstdc++/libgcc, for this distribution
#   ./build.sh --non-universal only; this turns --universal back off.
#   ./build.sh --non-static
#
#   ./build.sh --sync[=<re>]   Also update each portion of the tree's toolchain right after
#                              that portion builds, when its keyword matches the extended
#                              regexp <re> (default: every portion); the others still wait
#                              for the entire build. Keywords: clang (the compiler),
#                              crt (compiler-rt crt objects), unwind (libyolounwind),
#                              osinc (pizfix/os-include), yolo (yolo glibc), pas (libpas
#                              runtime, libpizlo), libc (user glibc), cxx (libc++ and
#                              libc++abi, with their headers in build/include).
#                              E.g. --sync='clang|pas'.
#   ./build.sh --no-sync       Leave the tree's toolchain as it is, even after the build.
#
#   ./build.sh --clean[=<re>]  Remove the build output that each portion whose keyword
#                              (as for --sync; not a path) matches <re> (default: all)
#                              keeps in the build folder (clang: the whole LLVM build).
#                              Only cleans, unless a build flag or --publish is also
#                              given (then it cleans each portion right before that
#                              portion builds).
#   ./build.sh --rebuild[=<re>]  --clean[=<re>], then a build: the matching portions build
#                              from scratch. When <re> matches clang (bare --rebuild does),
#                              it is a --nightly build (hours).
#
#   ./build.sh -d <dir>        Use <dir> as the build folder instead of ../build/<tree name>
#   ./build.sh --directory=<dir>  (a relative <dir> is taken from the current directory).
#
#   ./build.sh --archs=<list>  The CPU archs to build for, comma-separated (default: host,
#   ./build.sh --arch=<list>   the arch of this machine, detected). all = every arch
#                              Fil-C supports: x86_64 and aarch64 (also named amd64, x64;
#                              arm, arm64, armv8). Fil-C is 64-bit only, so armv7 or i686
#                              is refused. Another arch than the host's is cross-compiled:
#                              its sysroot, cross GCC and binutils come from the
#                              distribution's -cross packages (fetched rootless, as
#                              --prerequisites fetches bison), its runtime is compiled by the
#                              host's clang, which then needs that arch's LLVM target (a
#                              prebuilt one lacks it, so the host's clang is built from
#                              source), it builds in <build folder>-<arch>, and it is
#                              archived and published like the host's, but never synced
#                              into this tree (--no-build fetches nothing for it).
#
#   ./build.sh --no-xz         With a build, skip generating the .xz archive.
#   ./build.sh --no-archive    (alias of --no-xz)
#
#   ./build.sh --export        Only pack the toolchain this tree already uses (build/ +
#                              pizfix/) as upstream packs it: no build, no publishing. A
#                              musl one only (see --musl); a glibc toolchain is
#                              packed by a build, as the /opt/fil package.
#
#   ./build.sh --publish       Also publish the archive the run generates (a --nightly
#   ./build.sh --upload        build always packs one; the default build packs one only
#                              to publish it) on the release v<upstream version> (from this
#                              tree's upstream-<version> tag) of the
#                              compiler/ submodule's GitHub repo (where the default build
#                              downloads it from), when a git remote of that repo carries
#                              an access token in its URL: the archive becomes an asset
#                              listed by its file name, and the release's name and text
#                              (which describes each asset) are regenerated from all of
#                              its assets. Only an archive this run created,
#                              and that passes `xz -t`, is ever published; a failed build
#                              or export publishes nothing. After --export: publish the
#                              export.
#   ./build.sh --no-publish    Keep the archive local only (the default; this turns
#   ./build.sh --no-upload     publishing back off after --publish).
#
#   ./build.sh --no-build      With --publish: publish the archives already in dist/,
#   ./build.sh --no-rebuild    without building, and regenerate the release's name and
#                              text (only that, when dist/ holds no archive). With
#                              --clean: only clean. Otherwise: see above (fetch only).
#
#                              Flags take effect in order, so a later one overrides an
#                              earlier one: --no-publish --publish publishes, --sync
#                              --no-sync does not sync.
#
#   ./build.sh --glibc         The libc slice to build: glibc (the default), whose toolchain
#   ./build.sh --gnu           is then installed at /opt/fil like upstream's optfil package
#   ./build.sh --musl          (see --install), or musl, whose toolchain stays in this tree
#                              wherever it is. A Fil-C program uses the toolchain's own
#                              libc, never the host's, so the slice is the program's libc.
#                              --musl builds in its own build folder (<build folder>-musl,
#                              as the two cannot share a pizfix/), with the clang the glibc
#                              build folder built (so build that one first), and packs
#                              filc-<version>-linux-<arch>.xz with upstream's
#                              package-build.sh (setup.sh, licenses, README included).
#
#   ./build.sh --install       With --glibc: once the build is done, install the toolchain at
#   ./build.sh --setup         /opt/fil the way upstream's optfil/build_opt.sh does (both
#                              glibcs built again for that prefix, as root, straight into
#                              /opt/fil, which is emptied first), and pack it as
#                              optfil-<version>-linux-<arch>.xz. The default; it asks for the
#                              root password up front (sudo).
#   ./build.sh --no-install    Leave /opt/fil alone: the toolchain stays in the build folder
#   ./build.sh --no-setup      and this tree, where it finds its paths at run time; its
#                              optfil-<version>-linux-<arch>.xz is still made, built under
#                              the build folder's optfil-root/ for the /opt/fil prefix,
#                              with no root. A foreign arch's always is: it cannot be
#                              installed on this machine.
#
#   ./build.sh --headless      Never ask anything: without a root password at hand, --install
#                              warns and works as --no-install instead.
#
#   ./build.sh --prerequisites  Fetch build-only prerequisites that cannot be built from this
#                              tree: the GNU Bison data files (skeletons + m4sugar), in case
#                              the host bison lacks them, and the cross root of each
#                              foreign arch --archs names. A from-source build fetches
#                              them itself.
#
#   ./build.sh -h | --help
#
# Env overrides:
#   BUILD_DIR                The build folder (as -d), default ../build/<tree name>.
#   FILC_BUILD_DIR_SUFFIX    Appended to that default folder's name.
#   FILC_LIGHT_GITHUB_TOKEN  GitHub token for publishing, instead of the one found in the
#                            git remotes (see filc_github_token).
#   FILC_LIGHT_RELEASE_URL   Base URL that hosts the prebuilt optfil-<version>-linux-<arch>.xz
#                            packages. If unset, the compiler repo's GitHub releases: the
#                            one of the upstream version (…/releases/download/v<version>,
#                            from the upstream-<version> tag), then the latest one. If none
#                            has it, the default falls through to a from-source build.
#   HOST_CLANG               Native clang used to compile the runtime (default: clang).
#   HOSTCC / HOSTCXX         Native C/C++ compiler used to build clang itself
#                            (default: /usr/bin/clang, /usr/bin/clang++ -- lighter on RAM
#                            than gcc for an LLVM build).
set -euo pipefail

# From BASH_SOURCE, not $0, so tests/build.spec.sh can source this file.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS="$ROOT/.filc-light-tools"
DIST="$ROOT/dist"
HOST_CLANG="${HOST_CLANG:-clang}"
CLANGVER=20                       # LLVM major of the Fil-C fork (produces bin/clang-20)

# ---------- platform identity ----------
# Sets ARCH, the CPU arch the build is for: <arch>, else the host's.
filc_detect_platform() {   # [$1 = arch]
  ARCH="${1:-$(filc_host_arch)}"
}

# ---------- target CPU archs (--archs) ----------
# Every arch Fil-C supports: its compiler pass and its runtime know only these.
FILC_ARCHS="x86_64 aarch64"

# Prints the arch an --archs name means, or fails for an arch Fil-C lacks.
filc_arch_name() {   # $1 = name
  case "$1" in
    x86_64|x86-64|amd64|x64)         echo x86_64 ;;
    aarch64|arm64|arm|armv8|armv8-a) echo aarch64 ;;
    *) return 1 ;;
  esac
}

# Prints the arch of this machine (as uname names it when Fil-C lacks it).
filc_host_arch() {
  filc_arch_name "$(uname -m)" || uname -m
}

# Prints the archs an --archs list names (comma- or space-separated; all, host), each
# once, the host's first: a foreign arch's build reuses the host build folder's clang.
filc_parse_archs() {   # $1 = list
  local host want="" name a out
  host="$(filc_host_arch)"
  for name in $(printf '%s' "${1:-host}" | tr ',' ' '); do
    case "$name" in
      all)  want="$want $FILC_ARCHS" ;;
      host) want="$want $host" ;;
      *)
        if ! a="$(filc_arch_name "$name")"; then
          echo "--archs: Fil-C cannot target $name; it supports only the 64-bit archs: ${FILC_ARCHS// /, }." >&2
          return 2
        fi
        want="$want $a" ;;
    esac
  done
  out=""
  case " $want " in *" $host "*) out="$host" ;; esac
  for a in $FILC_ARCHS; do
    [ "$a" != "$host" ] || continue
    case " $want " in *" $a "*) out="$out $a" ;; esac
  done
  echo "${out# }"
}

# The LLVM target that generates code for <arch>.
filc_llvm_target() {   # $1 = arch
  case "$1" in
    x86_64)  echo X86 ;;
    aarch64) echo AArch64 ;;
  esac
}

# Prints the LLVM targets of <archs>, plus those the cmake cache in <dir> already has,
# joined by ";": the host clang keeps every target it was built with, so a later run
# that asks for fewer archs does not reconfigure it.
filc_llvm_targets() {   # $1 = cmake build dir, $2... = archs
  local want t out="" a
  want=" $(sed -n 's/^LLVM_TARGETS_TO_BUILD:[A-Z]*=//p' "$1/CMakeCache.txt" 2>/dev/null | tr ';' ' ') "
  shift
  for a in "$@"; do want="$want $(filc_llvm_target "$a") "; done
  for t in X86 AArch64; do
    case "$want" in *" $t "*) out="$out;$t" ;; esac
  done
  echo "${out#;}"
}

# Switches the build to <arch>: ARCH; BUILD_DIR, the arch's
# build folder (HOST_BUILD_DIR, or HOST_BUILD_DIR-<arch> for a foreign arch); CROSS, the
# target triple of a foreign arch (empty for the host's); and XROOT, a foreign arch's
# cross root (see filc_install_cross).
filc_use_arch() {   # $1 = arch
  filc_detect_platform "$1"
  BUILD_DIR="$HOST_BUILD_DIR"
  CROSS=""
  XROOT=""
  if [ "$1" != "$(filc_host_arch)" ]; then
    BUILD_DIR="$HOST_BUILD_DIR-$1"
    CROSS="$1-linux-gnu"
    XROOT="$TOOLS/cross-$1"
  fi
}

# Prints the LLVM build whose clang is archived: build/ in the build folder, but for a
# foreign arch clang-build/, as build/ there holds the host clang that compiles the
# runtime (see filc_cross_helper).
filc_clang_dir() {
  if [ -n "${CROSS:-}" ]; then echo "$BUILD_DIR/clang-build"; else echo "$BUILD_DIR/build"; fi
}

# The prebuilt toolchain (clang + pizfix) is published on the compiler/ submodule's repo's
# releases, not on this light repo -- so derive that repo from the submodule URL
# (.gitmodules is the single source of truth for it; never hardcode/duplicate the URL here).
# Prints its GitHub "<owner>/<repo>", or nothing when it is not on GitHub.
filc_compiler_repo_slug() {
  local url
  url="$(git -C "$ROOT" config -f "$ROOT/.gitmodules" submodule.compiler.url 2>/dev/null || true)"
  case "$url" in
    ../*)                 # relative submodule URL: resolve against origin's parent
      local o; o="$(git -C "$ROOT" remote get-url origin 2>/dev/null || true)"; o="${o%.git}"
      url="${o%/*}/${url#../}" ;;
  esac
  url="$(printf '%s' "$url" | sed -E 's#^(https?://)[^@/]*@#\1#')"   # drop credentials
  case "$url" in
    https://github.com/*) url="${url#https://github.com/}" ;;
    git@github.com:*)     url="${url#git@github.com:}" ;;
    *) return 0 ;;
  esac
  echo "${url%.git}"
}

# Base URLs for prebuilt archives, one per line, in the order to try: an explicit
# FILC_LIGHT_RELEASE_URL alone; else the compiler repo's release of the upstream version
# this tree is based on (v<version>, see filc_upstream_version), then its latest one.
filc_release_base_urls() {
  if [ -n "${FILC_LIGHT_RELEASE_URL:-}" ]; then echo "$FILC_LIGHT_RELEASE_URL"; return; fi
  local slug; slug="$(filc_compiler_repo_slug)"
  [ -n "$slug" ] || return 0
  echo "https://github.com/$slug/releases/download/v$(filc_upstream_version)"
  echo "https://github.com/$slug/releases/latest/download"
}

# Prints the GitHub access token of the first git remote whose URL carries one
# (https://<token>@github.com/... or https://<user>:<token>@github.com/...), preferring a
# remote of the <owner>/<repo> given, then any remote of the same owner; it looks at the
# compiler/ submodule's remotes, then this tree's own. Prints nothing when none has one.
filc_github_token() {   # $1 = <owner>/<repo>
  local want dir name url auth path
  for want in "$1" "${1%%/*}/"; do
    for dir in "$ROOT/compiler" "$ROOT"; do
      [ -e "$dir/.git" ] || continue
      for name in $(git -C "$dir" remote 2>/dev/null); do
        url="$(git -C "$dir" remote get-url --push "$name" 2>/dev/null || true)"
        case "$url" in https://*@github.com/*) ;; *) continue ;; esac
        auth="${url#https://}"; auth="${auth%%@*}"
        path="${url#*@github.com/}"; path="${path%.git}"
        case "$want" in
          */) [ "${path%%/*}/" = "$want" ] || continue ;;
          *)  [ "$path" = "$want" ] || continue ;;
        esac
        case "$auth" in *:*) auth="${auth#*:}" ;; esac
        if [ -n "$auth" ]; then printf '%s\n' "$auth"; return 0; fi
      done
    done
  done
}

# ---------- the prebuilt toolchain ----------
# Fetches the prebuilt toolchain of the current arch (the optfil package of the upstream
# version, see filc_fetch_optfil) and lays it out in <dir> (default: the tree) as build/ +
# pizfix/. Each step fails explicitly: callers run it in a || list, where set -e is off.
filc_download_toolchain() {   # [$1 = dir]
  local dest="${1:-$ROOT}" unpack="$TOOLS/unpack-$ARCH"
  filc_fetch_optfil "$unpack" || return 1
  echo "Unpacking it into $dest ..."
  mkdir -p "$dest"
  if ! tar -C "$unpack" -xJf "$unpack"/optfil-*/fil.tar.xz \
     || ! filc_optfil_to_tree "$unpack/fil" "$dest"; then
    echo "ERROR: cannot lay the prebuilt toolchain out in $dest." >&2
    rm -rf "$unpack"
    return 1
  fi
  rm -rf "$unpack"
  filc_relocate_ld_scripts "$dest/pizfix"
  filc_relocate_runpaths "$dest/pizfix"
  filc_set_interpreters "$dest/pizfix"
  filc_set_clang_interpreter "$dest"
  if [ -z "${CROSS:-}" ]; then   # a foreign arch's clang does not run here
    echo "Prebuilt toolchain ready: $("$dest/build/bin/clang" --version | head -1)"
  fi
}

# Fetches the prebuilt toolchain of the current arch, the optfil package of the upstream
# release this tree is based on (optfil-<version>-linux-<arch>.xz, see
# filc_upstream_version) from the release, and
# unpacks it into <dir> (emptied first): a folder optfil-<version>-linux-<arch> holding
# fil.tar.xz (the /opt/fil tree), setup.sh and the licenses. Returns 1 when there is none,
# or when what came is not such a package.
filc_fetch_optfil() {   # $1 = dir
  local bases base f unpack="$1" got=""
  bases="$(filc_release_base_urls)"
  if [ -z "$bases" ]; then
    echo "No prebuilt-release URL (set FILC_LIGHT_RELEASE_URL or add a GitHub 'origin')."
    return 1
  fi
  f="optfil-$(filc_upstream_version)-linux-$ARCH.xz"
  mkdir -p "$TOOLS"
  for base in $bases; do
    echo "Trying prebuilt $base/$f ..."
    if curl -fL --retry 2 -o "$TOOLS/$f" "$base/$f" 2>/dev/null; then got=1; break; fi
  done
  if [ -z "$got" ]; then
    rm -f "$TOOLS/$f"
    echo "No prebuilt archive $f available."
    return 1
  fi
  rm -rf "$unpack"
  mkdir -p "$unpack"
  if ! tar -C "$unpack" -xJf "$TOOLS/$f"; then
    rm -f "$TOOLS/$f"
    echo "ERROR: $f is not a valid archive." >&2
    return 1
  fi
  rm -f "$TOOLS/$f"
  set -- "$unpack"/optfil-*/fil.tar.xz
  if [ ! -f "$1" ]; then
    echo "ERROR: $f holds no optfil-*/fil.tar.xz; not an optfil package." >&2
    return 1
  fi
}

# --no-build with --install: installs the prebuilt toolchain of the current arch at
# /opt/fil in its flat layout, the way upstream's package does it (its setup.sh
# --unattended, as root), replacing what /opt/fil held, as a build's install does
# (setup.sh refuses an existing /opt/fil).
filc_download_install() {
  local unpack="$TOOLS/unpack-$ARCH"
  filc_fetch_optfil "$unpack" || return 1
  # Only a package that can install replaces /opt/fil.
  set -- "$unpack"/optfil-*/setup.sh
  if [ ! -x "$1" ]; then
    echo "ERROR: the prebuilt package holds no setup.sh; /opt/fil is left as it is." >&2
    rm -rf "$unpack"
    return 1
  fi
  echo "===== optfil: installing the prebuilt toolchain at /opt/fil (its old content is replaced) ====="
  sudo rm -rf /opt/fil
  ( cd "$unpack"/optfil-*/ && sudo ./setup.sh --unattended ) || { rm -rf "$unpack"; return 1; }
  rm -rf "$unpack"
  echo "Prebuilt toolchain ready: $(/opt/fil/bin/filcc --version | head -1)"
}

# Marks the toolchain whose clang is in <dir>/bin as a Fil-C-Light one, apart from an
# upstream Fil-C (both name their clang alike): the file <dir>/share/fil-c-light.ini,
# whose [Version] group gives Light's own version, the upstream release it is based on
# and its libc (glibc or musl; values unquoted, as QSettings reads them). XD's build-handler looks for it to
# prefer Light.
filc_light_stamp() {   # $1 = dir (the one holding bin/), [$2 = its libc, else LIBC]
  mkdir -p "$1/share"
  printf '[Version]\nlight=%s\nupstream=%s\nlibc=%s\n' "$(filc_light_version)" \
    "$(filc_upstream_version)" "${2:-${LIBC:-glibc}}" > "$1/share/fil-c-light.ini"
}

# Prints the git to run; returns 1 when there is none.
filc_find_git() {
  command -v git
}

# Prints the nearest tag before HEAD that matches <glob>, without <prefix>; nothing
# without git (see filc_find_git), outside a checkout, or with no such tag.
filc_tag_version() {   # $1 = glob, $2 = prefix
  local git tag
  git="$(filc_find_git)" || return 0
  tag="$("$git" -C "$ROOT" describe --tags --abbrev=0 --match "$1" HEAD 2>/dev/null)" || return 0
  echo "${tag#"$2"}"
}

# Prints Fil-C-Light's own version: its nearest version tag ("1.0.0"), else 1.0.0.
filc_light_version() {
  local v
  v="$(filc_tag_version '[0-9]*.[0-9]*.[0-9]*' '')"
  echo "${v:-1.0.0}"
}

# Prints the upstream Fil-C release this tree is based on: its nearest upstream-<version>
# tag ("upstream-0.686" gives 0.686), else 0.680.
filc_upstream_version() {
  local v
  v="$(filc_tag_version 'upstream-*' upstream-)"
  echo "${v:-0.680}"
}

# Lays the /opt/fil tree <fil> (an optfil package's payload) out as this tree does:
# the clang, its resource folder and libc++'s headers under build/, everything else
# under pizfix/, where the Fil-C driver finds it beside build/ (it searches /opt/fil
# only when it runs from /opt/fil/bin, and include, stdfil-include and os-include of
# pizfix/ when it finds one, so all the headers in include/ serve).
filc_optfil_to_tree() {   # $1 = fil dir, $2 = dest dir
  local fil="$1" dest="$2" d
  mkdir -p "$dest/build/bin" "$dest/build/lib" "$dest/build/include" \
           "$dest/pizfix/stdfil-include" "$dest/pizfix/os-include" || return 1
  mv "$fil/bin/filcc-clang-$CLANGVER" "$dest/build/bin/clang-$CLANGVER" || return 1
  ln -sf "clang-$CLANGVER" "$dest/build/bin/clang"
  ln -sf "clang-$CLANGVER" "$dest/build/bin/clang++"
  # filcc, fil++ and filcpp name the clang that moved.
  find "$fil/bin" -maxdepth 1 -type l -lname "*clang-$CLANGVER" -delete
  mv "$fil/lib/clang" "$dest/build/lib/clang" || return 1
  mv "$fil/include/c++" "$dest/build/include/c++" || return 1
  for d in "$fil"/include/*-linux-gnu; do
    [ -d "$d/c++" ] || continue
    mkdir -p "$dest/build/include/${d##*/}"
    mv "$d/c++" "$dest/build/include/${d##*/}/c++" || return 1
    rmdir "$d" 2>/dev/null || true
  done
  mkdir -p "$dest/pizfix"
  rm -f "$fil/share/fil-c-light.ini"
  cp -a "$fil/." "$dest/pizfix/" || return 1
  filc_light_stamp "$dest/build" glibc   # an optfil package is the glibc toolchain
}

# Points the clang of <dir>/build/bin at the loader and libraries of <dir>/pizfix: an
# optfil package's clang runs on the package's own yolo glibc, named from /opt/fil.
filc_set_clang_interpreter() {   # $1 = dir
  local clang="$1/build/bin/clang-$CLANGVER" ld
  ld="$(cd "$1/pizfix/lib" && pwd)/ld-fil1-$ARCH.so"
  [ -f "$clang" ] && [ -f "$ld" ] || return 0
  case "$(patchelf --print-interpreter "$clang" 2>/dev/null)" in
    /opt/fil/*|*/pizfix/*) ;;
    *) return 0 ;;
  esac
  patchelf --set-interpreter "$ld" --set-rpath '$ORIGIN/../../pizfix/lib' "$clang"
}

# Builds this tree's own portions of the current arch (see filc_use_arch), the runtime
# and libc layers, with the clang of the compiler/ repo: the whole prebuilt toolchain is
# laid down first, in the build folder and (unless --no-sync) the tree, so the tree has a
# whole toolchain even if the build fails, and what is not rebuilt here, libc++ (its
# sources are the compiler/ repo's), is the prebuilt one's. A build folder that built its
# clang from source (by --nightly) keeps it, as a prebuilt one would overwrite that LLVM
# build's output; that clang is then synced too, as the runtime must come from the same
# clang as the tree's, and libc++ is built with it. Then syncs, and packs and publishes
# only with --publish. Returns 1 when no prebuilt toolchain can be fetched.
filc_light_arch() {   # $1 = marker file of the run's start
  local started="$1" cdir stage="" tag
  BUILT=""
  SYNCED=""
  cdir="$(filc_clang_dir)"
  if [ "$LIBC" = glibc ] && [ ! -f "$cdir/CMakeCache.txt" ]; then
    stage="$TOOLS/prebuilt-$ARCH"
    rm -rf "$stage"
    filc_download_toolchain "$stage" || { rm -rf "$stage"; return 1; }
    if [ -z "$CROSS" ] && [ "$SYNC" = 1 ]; then
      echo "Unpacking the prebuilt toolchain into the tree ..."
      rm -rf "$ROOT/build/bin" "$ROOT/build/lib/clang" "$ROOT/build/include"
      mkdir -p "$ROOT/build"
      cp -a "$stage/build/." "$ROOT/build/"
      rm -rf "$ROOT/pizfix"
      cp -a "$stage/pizfix" "$ROOT/pizfix"
      filc_set_interpreters "$ROOT/pizfix"
    fi
    # The runtime builds on the prebuilt one, which also brings what is not rebuilt.
    mkdir -p "$BUILD_DIR/pizfix"
    cp -a "$stage/pizfix/." "$BUILD_DIR/pizfix/"
    filc_set_interpreters "$BUILD_DIR/pizfix"
  fi
  filc_mirror
  if [ -n "$CROSS" ]; then
    filc_install_cross "$ARCH"
    filc_cross_helper
  fi
  if [ -z "$stage" ]; then
    if [ "$LIBC" = glibc ]; then
      echo "This build folder built its clang from source; building with it: $cdir"
    else
      echo "--$LIBC builds with the clang of the glibc build folder (see filc_borrow_clang)."
    fi
    filc_build_clang "${STATIC:-any}"
    BUILT="$BUILT clang"
  else
    rm -rf "$cdir/bin" "$cdir/lib/clang"
    mkdir -p "$cdir/lib"
    cp -a "$stage/build/bin" "$cdir/bin"
    cp -a "$stage/build/lib/clang" "$cdir/lib/clang"
    # libc++'s headers, beside the clang that compiles.
    rm -rf "$BUILD_DIR/build/include"
    if [ -d "$stage/build/include" ]; then
      mkdir -p "$BUILD_DIR/build"
      cp -a "$stage/build/include" "$BUILD_DIR/build/include"
    fi
    rm -rf "$stage"
  fi
  if [ -n "$stage" ]; then
    filc_build_runtime_libc no-cxx
    filc_cxx_built || echo "WARNING: the prebuilt $ARCH toolchain lacks libc++ (or its headers); --nightly builds it." >&2
  else
    filc_build_runtime_libc
  fi
  filc_sync_arch
  [ "$PUBLISH" != 1 ] || filc_pack_arch "$started"
}

# ---------- the build folder: a mirror of the tree ----------
# Mirrors the tree's sources into the build folder, where upstream's scripts build
# unchanged: the read-only compiler/ sources and filc/ are linked, everything upstream
# writes into is copied (no --delete, so earlier build output there stays incremental).
# A file the tree no longer has is removed from there too, found from the list of files
# the previous mirror copied (a build would otherwise still pick up, say, a deleted .S
# over the .c that replaces it); build output is never in that list.
# A missing pizfix/ there starts as a copy of the tree's, so a portion that is not rebuilt
# still finds the runtime it builds on; a foreign arch's build folder starts with none,
# as the tree's runtime is the host's.
filc_mirror() {
  local list="$BUILD_DIR/.filc-mirror.list" f
  mkdir -p "$BUILD_DIR"
  ( cd "$ROOT" && find . \( -path ./.git -o -path ./build -o -path ./pizfix -o -path ./dist \
        -o -path ./.filc-light-tools -o -path ./tmp-build -o -path ./compiler -o -path ./filc \) \
        -prune -o \( -type f -o -type l \) -print ) | sed 's#^\./##' | LC_ALL=C sort > "$list.new"
  if [ -f "$list" ]; then
    LC_ALL=C comm -23 "$list" "$list.new" | while IFS= read -r f; do
      rm -f "${BUILD_DIR:?}/$f"
    done
  fi
  mv -f "$list.new" "$list"
  rsync -a \
    --exclude=/.git --exclude=/build/ --exclude=/pizfix/ --exclude=/dist/ \
    --exclude=/.filc-light-tools/ --exclude=/tmp-build/ --exclude=/compiler --exclude=/filc \
    "$ROOT/" "$BUILD_DIR/"
  local d
  for d in compiler filc; do
    [ -L "$BUILD_DIR/$d" ] || { rm -rf "${BUILD_DIR:?}/$d"; ln -s "$ROOT/$d" "$BUILD_DIR/$d"; }
  done
  if [ -z "${CROSS:-}" ] && [ ! -d "$BUILD_DIR/pizfix" ] && [ -d "$ROOT/pizfix" ]; then
    cp -a "$ROOT/pizfix" "$BUILD_DIR/pizfix"
  fi
}

# ---------- cleaning portions (--clean, and --rebuild through it) ----------
FILC_PORTIONS="clang crt unwind osinc yolo pas libc cxx"

# A portion's keyword is cleaned when it matches FILC_CLEAN_FILTER (an extended regexp
# over the keywords, not over paths); an empty filter matches none.
filc_clean_filter() {   # $1 = portion keyword
  [ -n "$FILC_CLEAN_FILTER" ] && printf '%s\n' "$1" | grep -Eq -- "$FILC_CLEAN_FILTER"
}

# Removes the build output a portion keeps in the build folder, so it builds from
# scratch; what it installed into the build folder's pizfix/ stays. osinc keeps none.
filc_clean_portion() {   # $1 = portion keyword
  case "$1" in
    clang)  rm -rf "${BUILD_DIR:?}/${CROSS:+clang-}build" ;;   # filc_clang_dir
    crt)    rm -rf "${BUILD_DIR:?}/compiler-rt/build" ;;
    unwind) rm -f "${BUILD_DIR:?}"/yolounwind/*.o "${BUILD_DIR:?}"/yolounwind/*.a ;;
    yolo)   rm -rf "${BUILD_DIR:?}/pizlonated-yolo-glibc-build" ;;
    pas)    rm -rf "${BUILD_DIR:?}/libpas/build" ;;
    libc)   rm -rf "${BUILD_DIR:?}/pizlonated-user-glibc-build" ;;
    cxx)    rm -rf "${BUILD_DIR:?}/cxx-build" "${BUILD_DIR:?}/cxx-install" ;;
    *)      return 0 ;;
  esac
  echo "clean: removed the $1 build output."
}

# Cleans every portion the filter matches, building nothing.
filc_clean_all() {
  local kw
  if [ ! -d "$BUILD_DIR" ]; then
    echo "clean: no build folder at $BUILD_DIR; nothing to clean."
    return 0
  fi
  for kw in $FILC_PORTIONS; do
    if filc_clean_filter "$kw"; then filc_clean_portion "$kw"; fi
  done
}

# ---------- syncing built portions into the tree ----------
# A portion's keyword passes when it matches FILC_SYNC_FILTER (an extended regexp); an
# empty filter passes none, which is the default until the entire build is done. A
# foreign arch's build passes none: the tree's toolchain must run on this host.
filc_sync_filter() {   # $1 = portion keyword
  [ -z "${CROSS:-}" ] && [ -n "$FILC_SYNC_FILTER" ] \
    && printf '%s\n' "$1" | grep -Eq -- "$FILC_SYNC_FILTER"
}

# Copies one file (or symlink) at <path>, relative to both trees, from the build folder
# into the tree, replacing the old one in a single rename; a no-op for a portion the
# filter does not pass.
filc_sync_file() {   # $1 = portion keyword, $2 = path
  filc_sync_filter "$1" || return 0
  local src="$BUILD_DIR/$2" dst="$ROOT/$2"
  [ -e "$src" ] || [ -L "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst.filc-sync.$$"
  mv -f "$dst.filc-sync.$$" "$dst"
}

# As filc_sync_file, for a whole folder: the new copy is completed beside the old one,
# then swapped in.
filc_sync_dir() {   # $1 = portion keyword, $2 = path
  filc_sync_filter "$1" || return 0
  local src="$BUILD_DIR/$2" dst="$ROOT/$2"
  [ -d "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  rm -rf "$dst.filc-sync.$$"
  cp -a "$src" "$dst.filc-sync.$$"
  if [ -e "$dst" ]; then mv "$dst" "$dst.filc-old.$$"; fi
  mv "$dst.filc-sync.$$" "$dst"
  rm -rf "$dst.filc-old.$$"
}

# Syncs the files the portion <keyword> produced: clang its bin/ and lib/clang, osinc
# and yolo their own pizfix/ folders, the others the pizfix/ files their manifest
# (written by filc_portion) lists.
filc_sync_portion() {   # $1 = portion keyword
  local f
  case "$1" in
    clang) filc_sync_dir clang build/bin; filc_sync_dir clang build/lib/clang ;;
    osinc) filc_sync_dir osinc pizfix/os-include ;;
    yolo)  filc_sync_dir yolo pizfix/yolo ;;
    cxx)
      filc_sync_dir cxx build/include
      while IFS= read -r f; do filc_sync_file cxx "$f"; done < "$BUILD_DIR/.filc-portions/cxx.list"
      ;;
    *)
      [ -f "$BUILD_DIR/.filc-portions/$1.list" ] || return 0
      while IFS= read -r f; do filc_sync_file "$1" "$f"; done < "$BUILD_DIR/.filc-portions/$1.list"
      ;;
  esac
  if filc_sync_filter "$1"; then SYNCED="$SYNCED $1"; echo "synced: $1"; fi
}

# The sources a portion builds from, relative to the tree (the build scripts' own
# changes are left out: they do not change what a portion builds).
filc_portion_sources() {   # $1 = portion keyword
  case "$1" in
    crt)    echo "compiler-rt build_compiler_rt.sh configure_cmake_project.sh" ;;
    unwind) echo "yolounwind build_yolounwind.sh" ;;
    osinc)  echo "build_os_include.sh" ;;
    yolo)
      case "${LIBC:-glibc}" in
        musl)  echo "projects/yolomusl build_yolomusl.sh" ;;
        *)     echo "projects/yolo-glibc-2.44 projects/binary-root.c build_yolo_glibc.sh fix_yolo_glibc.sh" ;;
      esac ;;
    pas)    echo "libpas filc build_runtime.sh" ;;
    libc)
      case "${LIBC:-glibc}" in
        musl)  echo "projects/usermusl filc/include build_usermusl.sh" ;;
        *)     echo "projects/user-glibc-2.44 projects/binary-root.c projects/libxcrypt-4.5.2 filc/include build_user_glibc.sh build_xcrypt.sh" ;;
      esac ;;
    cxx)    echo "compiler/runtimes compiler/libcxx compiler/libcxxabi compiler/cmake" ;;
  esac
}

# Tells whether the portion <keyword> is current in the build folder: it built there
# before (its manifest, written once it succeeded, exists), every file it installed is
# still there, and none of its sources changed since.
filc_portion_current() {   # $1 = portion keyword
  local list="$BUILD_DIR/.filc-portions/$1.list" src p f
  src="$(filc_portion_sources "$1")"
  [ -n "$src" ] && [ -s "$list" ] || return 1
  while IFS= read -r f; do
    [ -e "$BUILD_DIR/$f" ] || [ -L "$BUILD_DIR/$f" ] || return 1
  done < "$list"
  for p in $src; do
    [ -e "$ROOT/$p" ] || continue
    if [ -n "$(find "$ROOT/$p" -newer "$list" ! -path '*/.git/*' -print -quit 2>/dev/null)" ]; then
      return 1
    fi
  done
}

# Runs <command> in the build folder as the portion <keyword> (for a foreign arch, with
# the cross tools of filc_cross_env), records the pizfix/ files it wrote in that
# portion's manifest, and syncs it when --sync's filter passes it. A portion that is
# current (see filc_portion_current) is kept as it is, unless --clean or --rebuild asks.
filc_portion() {   # $1 = portion keyword, $2... = command
  local kw="$1" marker
  shift
  if ! filc_clean_filter "$kw" && filc_portion_current "$kw"; then
    echo "===== $kw: unchanged since its last build; kept ====="
    return 0
  fi
  if filc_clean_filter "$kw"; then filc_clean_portion "$kw"; fi
  mkdir -p "$BUILD_DIR/.filc-portions"
  marker="$BUILD_DIR/.filc-portions/$kw.start"
  : > "$marker"
  echo "===== $kw: $* ====="
  ( cd "$BUILD_DIR"
    if [ -n "${CROSS:-}" ]; then filc_cross_env; fi
    "$@" )
  ( cd "$BUILD_DIR" && find pizfix -newer "$marker" \( -type f -o -type l \) 2>/dev/null ) \
    > "$BUILD_DIR/.filc-portions/$kw.list"
  BUILT="$BUILT $kw"
  filc_sync_portion "$kw"
}

# Brings the tree up to date once the entire build is done. clang is synced unless --sync
# already copied its folders. The runtime portions are always taken as the whole pizfix/
# folder, swapped in at once, even when --sync copied them early: an early sync copies
# only the files its manifest found by time, so files an install left with old times
# arrive only here.
filc_sync_all() {
  local kw runtime=""
  FILC_SYNC_FILTER='^.*$'
  for kw in $BUILT; do
    case "$kw" in
      clang)
        case " $SYNCED " in *" clang "*) ;; *) filc_sync_portion clang ;; esac ;;
      cxx)
        runtime=1
        filc_sync_dir cxx build/include ;;
      *) runtime=1 ;;
    esac
  done
  if [ -n "$runtime" ]; then
    filc_sync_dir runtime pizfix
    filc_set_interpreters "$ROOT/pizfix"
    echo "synced: the pizfix/ runtime"
  fi
}

# ---------- from-source: the compiler ----------
# Prints how many jobs upstream's scripts run at once: NCPU of the build folder's
# libpas/common.sh, read in a subshell, as common.sh also sets ARCH, to the host's.
filc_ncpu() {
  # shellcheck disable=SC1091
  ( . "$BUILD_DIR/libpas/common.sh" > /dev/null && echo "${NCPU:-1}" )
}

# Tells whether <clang> (default: the build folder's, see filc_clang_dir) links the C++
# runtime statically (the universal linkage): its dynamic dependencies name no libstdc++
# and no libgcc_s.
filc_clang_is_universal() {   # [$1 = clang binary]
  ! readelf -d "${1:-$(filc_clang_dir)/bin/clang-$CLANGVER}" 2>/dev/null \
    | grep -qE 'NEEDED.*(libstdc\+\+|libgcc_s)'
}

# Prints the newest GLIBC symbol version <clang> (default: the build folder's) needs,
# i.e. the oldest glibc it runs on, or nothing when readelf cannot tell. readelf reads
# a binary of any arch.
filc_clang_glibc_floor() {   # [$1 = clang binary]
  readelf -W --dyn-syms "${1:-$(filc_clang_dir)/bin/clang-$CLANGVER}" 2>/dev/null \
    | grep -o 'GLIBC_[0-9][0-9.]*' | sed 's/GLIBC_//' | sort -uV | tail -1
}

# Builds the clang of the build folder (see filc_clang_dir) with the C++ runtime linkage
# asked for: static (universal), dynamic, or any (keep the one it has; dynamic for a new
# build). The host's clang gets the LLVM target of every arch in ARCHS, as it compiles
# the runtime of each; a foreign arch's clang is cross-compiled for that arch alone.
filc_build_clang() {   # $1 = static, dynamic (or empty) or any
  local dir clang link="${1:-dynamic}" targets
  dir="$(filc_clang_dir)"
  clang="$dir/bin/clang-$CLANGVER"
  if [ "${LIBC:-glibc}" != glibc ]; then
    filc_borrow_clang
    return 0
  fi
  if filc_clean_filter clang; then filc_clean_portion clang; fi
  if [ -n "${CROSS:-}" ]; then
    targets="$(filc_llvm_target "$ARCH")"
  else
    # shellcheck disable=SC2086
    targets="$(filc_llvm_targets "$dir" "$(filc_host_arch)" ${ARCHS:-})"
  fi
  if [ "$link" = any ]; then
    link=dynamic
    if [ -x "$clang" ] && filc_clang_is_universal "$clang"; then link=static; fi
  fi
  if [ -x "$clang" ]; then
    if [ "$(filc_llvm_targets "$dir")" != "$targets" ]; then
      # The objects of the targets it has are kept; only the new ones compile.
      echo "clang lacks an LLVM target of $targets; reconfiguring it ..."
    elif { [ "$link" = static ] && filc_clang_is_universal "$clang"; } \
        || { [ "$link" != static ] && ! filc_clang_is_universal "$clang"; }; then
      if [ -n "${CROSS:-}" ]; then
        echo "clang for $ARCH already built: $clang"
      else
        echo "clang already built: $("$clang" --version | head -1)"
      fi
      return
    else
      # The other linkage: the same cmake run below only re-links clang, as every
      # object is still there.
      echo "clang is built with the other C++ runtime linkage; re-linking it ..."
    fi
  elif [ ! -f "$dir/CMakeCache.txt" ]; then
    echo "No clang build in $dir yet; compiling LLVM+Clang from scratch (hours)."
  fi
  # The llvm+clang+cmake sources live in the compiler/ submodule; init it if needed.
  if [ ! -e "$ROOT/compiler/llvm/CMakeLists.txt" ]; then
    echo "Initialising the compiler/ submodule (llvm+clang+cmake) ..."
    git -C "$ROOT" -c protocol.file.allow=always submodule update --init compiler
  fi
  # LLVM's build wants llvm/, clang/ and the repo-root cmake/ as siblings at the tree root.
  local d
  for d in llvm clang cmake; do
    [ -e "$BUILD_DIR/$d" ] || ln -s "compiler/$d" "$BUILD_DIR/$d"
  done
  local ncpu
  ncpu="$(filc_ncpu)"
  # The repository and revision clang --version names, without the access token a remote
  # URL may carry (LLVM refuses to embed one).
  local vcrepo vcrev
  vcrepo="$(git -C "$ROOT/compiler" remote get-url origin 2>/dev/null \
            | sed -E 's#^(https?://)[^@/]*@#\1#' || true)"
  vcrev="$(git -C "$ROOT/compiler" rev-parse HEAD 2>/dev/null || true)"
  # Both ways are spelled out, as cmake keeps a cached value from the previous run.
  local extra="-DLLVM_STATIC_LINK_CXX_STDLIB=OFF -DCMAKE_EXE_LINKER_FLAGS="
  if [ "$link" = static ]; then
    # Portable: fold the C++ runtime into the binary so it runs regardless of the host's
    # libstdc++/libgcc version. (glibc stays dynamic -- it is backward compatible, and a
    # fully-static libc clang is impractical: NSS/dlopen.)
    extra="-DLLVM_STATIC_LINK_CXX_STDLIB=ON -DCMAKE_EXE_LINKER_FLAGS=-static-libgcc"
  fi
  local -a cross=()
  if [ -n "${CROSS:-}" ]; then
    # The host clang compiles for the arch against its cross root, and the host build
    # folder's tablegens (built with the host clang) generate the sources.
    cross=(-DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR="$ARCH"
           -DCMAKE_SYSROOT="$XROOT"
           -DCMAKE_C_COMPILER_TARGET="$CROSS" -DCMAKE_CXX_COMPILER_TARGET="$CROSS"
           -DCMAKE_ASM_COMPILER_TARGET="$CROSS"
           -DLLVM_HOST_TRIPLE="$CROSS" -DLLVM_NATIVE_TOOL_DIR="$HOST_BUILD_DIR/build/bin")
  fi
  export TMPDIR="$BUILD_DIR/tmp-build"; mkdir -p "$TMPDIR"
  mkdir -p "$dir"
  ( cd "$dir"
    # cmake's compiler checks link with the cross binutils, which need their libbfd.
    if [ -n "${CROSS:-}" ]; then
      export LD_LIBRARY_PATH; LD_LIBRARY_PATH="$(filc_cross_libdir)${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    fi
    cmake -S ../llvm -B . -G Ninja \
      -DLLVM_ENABLE_PROJECTS=clang \
      -DLLVM_FORCE_VC_REPOSITORY="$vcrepo" \
      -DLLVM_FORCE_VC_REVISION="$vcrev" \
      -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_LLD=ON -DLLVM_TARGETS_TO_BUILD="$targets" \
      -DCMAKE_C_COMPILER="${HOSTCC:-/usr/bin/clang}" \
      -DCMAKE_CXX_COMPILER="${HOSTCXX:-/usr/bin/clang++}" \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF \
      -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_LIBPFM=OFF \
      -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_ZSTD=OFF -DLLVM_ENABLE_CURL=OFF \
      -DLLVM_ENABLE_HTTPLIB=OFF \
      $extra "${cross[@]}"
    ninja -j "$ncpu" clang
    # fix_clang.sh: drop the build rpath and add the Fil-C driver aliases.
    patchelf --remove-rpath "bin/clang-$CLANGVER" 2>/dev/null || true
    ( cd bin && for l in filcc fil++ filcpp; do ln -fs "clang-$CLANGVER" "$l"; done ) )
  BUILT="$BUILT clang"
  filc_sync_portion clang
}

# A musl build folder builds no LLVM: it takes the clang its glibc build folder built
# (the clang does not depend on the libc), hard-linked: for this machine's arch build/bin's
# clang-<ver> and its lib/clang, for a foreign arch clang-build/'s (build/ there holds the
# helper of filc_cross_helper, taken from this machine's musl folder the same way). Fails
# when the glibc build folder has no clang.
filc_borrow_clang() {
  local gdir="$FILC_GLIBC_BUILD_DIR" sub=build dir from l
  if [ -n "${CROSS:-}" ]; then gdir="$FILC_GLIBC_BUILD_DIR-$ARCH"; sub=clang-build; fi
  from="$gdir/$sub"
  dir="$(filc_clang_dir)"
  if [ ! -f "$from/bin/clang-$CLANGVER" ]; then
    echo "ERROR: --$LIBC takes the clang of the glibc build folder, and $from has none:" \
         "build the glibc toolchain of $ARCH first (./build.sh --nightly)." >&2
    exit 1
  fi
  mkdir -p "$dir/bin" "$dir/lib"
  rm -f "$dir/bin/clang-$CLANGVER"
  ln "$from/bin/clang-$CLANGVER" "$dir/bin/clang-$CLANGVER" 2>/dev/null \
    || cp "$from/bin/clang-$CLANGVER" "$dir/bin/clang-$CLANGVER"
  for l in clang clang++ filcc fil++ filcpp; do ln -sfn "clang-$CLANGVER" "$dir/bin/$l"; done
  rm -rf "$dir/lib/clang"
  cp -a "$from/lib/clang" "$dir/lib/clang"
  echo "clang taken from the glibc build folder: $from"
  BUILT="$BUILT clang"
  filc_sync_portion clang
}

# ---------- cross-compiling a foreign arch ----------
# The Debian name of <arch>, as its -cross packages spell it.
filc_deb_arch() {   # $1 = arch
  case "$1" in
    x86_64)  echo amd64 ;;
    aarch64) echo arm64 ;;
  esac
}

# Fetches the cross root of <arch> into $TOOLS/cross-<arch>, rootless (apt-get download
# and dpkg-deb -x, as for bison): the arch's glibc, kernel headers, libgcc and libstdc++
# (shared and static, for the universal clang) for its clang to link against, and a
# cross GCC (the yolo glibc builds only with GCC) with its binutils, of the host GCC's
# major version.
filc_install_cross() {   # $1 = arch
  local root="$TOOLS/cross-$1" deb triple ver p
  if [ -f "$root/.complete" ]; then
    echo "cross root for $1 already present under $root"; return
  fi
  deb="$(filc_deb_arch "$1")"
  triple="$(printf '%s' "$1-linux-gnu" | tr _ -)"   # x86-64-linux-gnu in package names
  ver="$(gcc -dumpversion | cut -d. -f1)"
  echo "Fetching the $1 cross root (sysroot, GCC $ver, binutils) ..."
  rm -rf "$root"; mkdir -p "$root/deb"
  ( cd "$root/deb"
    apt-get download "libc6-dev-$deb-cross" "libc6-$deb-cross" "linux-libc-dev-$deb-cross" \
      "libgcc-$ver-dev-$deb-cross" "libgcc-s1-$deb-cross" \
      "libstdc++-$ver-dev-$deb-cross" "libstdc++6-$deb-cross" \
      "gcc-$ver-$triple" "cpp-$ver-$triple" "gcc-$ver-$triple-base" "binutils-$triple" )
  for p in "$root"/deb/*.deb; do dpkg-deb -x "$p" "$root"; done
  rm -rf "$root/deb"
  : > "$root/.complete"
  echo "cross root for $1 installed at $root"
}

# A foreign arch's runtime is compiled by a Fil-C clang that runs here: the host build
# folder's, built with that arch's LLVM target too, is hard-linked into this build
# folder's build/bin, where clang.cfg and clang++.cfg aim it at the arch. The Fil-C
# driver takes pizfix/ from beside the binary it runs as, so it then builds against this
# folder's runtime, not the host's.
filc_cross_helper() {
  ( filc_use_arch "$(filc_host_arch)"
    FILC_CLEAN_FILTER=""; FILC_SYNC_FILTER=""
    filc_mirror
    filc_build_clang any )
  local from="$HOST_BUILD_DIR/build" bin="$BUILD_DIR/build/bin" l
  mkdir -p "$bin" "$BUILD_DIR/build/lib"
  rm -f "$bin/clang-$CLANGVER"
  ln "$from/bin/clang-$CLANGVER" "$bin/clang-$CLANGVER" 2>/dev/null \
    || cp "$from/bin/clang-$CLANGVER" "$bin/clang-$CLANGVER"
  for l in clang clang++; do
    ln -sfn "clang-$CLANGVER" "$bin/$l"
    printf -- '--target=%s\n' "$CROSS" > "$bin/$l.cfg"
  done
  ln -sfn "$from/lib/clang" "$BUILD_DIR/build/lib/clang"
}

# The folder of the host's shared libraries in the cross root (its binutils' libbfd).
filc_cross_libdir() {
  echo "$XROOT/usr/lib/$(filc_host_arch)-linux-gnu"
}

# Writes the commands filc_cross_env puts first on PATH, so upstream's scripts build for
# the arch unchanged: uname and arch name the arch; gcc, cc and cpp are the cross GCC;
# clang, clang++, c++ and g++ the host clang aimed at the arch; ld, as and the other
# binutils the cross ones. Also writes the config.site that tells glibc's configure it
# cross-compiles (so it never runs what it builds).
filc_cross_tools() {
  local dir="$BUILD_DIR/.filc-cross" bin uname clang hostarch gccver t libdir
  bin="$dir/bin"
  uname="$(command -v uname)"
  clang="$(command -v "${HOST_CLANG:-clang}")"
  hostarch="$(filc_host_arch)"
  libdir="$(filc_cross_libdir)"
  gccver="$(cd "$XROOT/usr/bin" && ls "$CROSS"-gcc-[0-9]* 2>/dev/null | head -1)"
  gccver="${gccver##*-}"
  rm -rf "$dir"; mkdir -p "$bin"
  printf '#!/bin/sh\n"%s" "$@" | sed "s/%s/%s/g"\n' "$uname" "$hostarch" "$ARCH" > "$bin/uname"
  printf '#!/bin/sh\necho %s\n' "$ARCH" > "$bin/arch"
  for t in gcc cc cpp; do
    printf '#!/bin/sh\nLD_LIBRARY_PATH="%s${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" exec "%s" --sysroot="%s" "$@"\n' \
      "$libdir" "$XROOT/usr/bin/$CROSS-$([ "$t" = cpp ] && echo cpp || echo gcc)-$gccver" "$XROOT" > "$bin/$t"
  done
  for t in clang clang++ c++ g++; do
    printf '#!/bin/sh\nLD_LIBRARY_PATH="%s${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" exec "%s" %s--target=%s --sysroot="%s" "$@"\n' \
      "$libdir" "$clang" "$(case "$t" in clang) ;; *) echo '--driver-mode=g++ ' ;; esac)" \
      "$CROSS" "$XROOT" > "$bin/$t"
  done
  for t in ld as ar nm ranlib objcopy objdump readelf strip; do
    printf '#!/bin/sh\nLD_LIBRARY_PATH="%s${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}" exec "%s" "$@"\n' \
      "$libdir" "$XROOT/usr/bin/$CROSS-$t" > "$bin/$t"
  done
  chmod +x "$bin"/*
  echo 'cross_compiling=yes' > "$dir/config.site"
}

# Puts the commands of filc_cross_tools first on PATH, for a portion of a foreign arch's
# build; glibc builds its own helper programs with the host GCC (BUILD_CC). The cross
# binutils find their libraries (named for the arch, so nothing else picks them up) even
# when run by path: glibc's configure runs the ld that `gcc -print-prog-name=ld` names.
filc_cross_env() {
  export BUILD_CC; BUILD_CC="$(command -v gcc)"
  export LD_LIBRARY_PATH; LD_LIBRARY_PATH="$(filc_cross_libdir)${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  export PATH="$BUILD_DIR/.filc-cross/bin:$PATH"
  export HOST_CLANG=clang   # libpas compiles the runtime's C parts with it
  export CONFIG_SITE="$BUILD_DIR/.filc-cross/config.site"
}

# The osinc portion of a foreign arch: build_os_include.sh would link the host's kernel
# headers, so the cross root's are linked instead (a package leaves pizfix/os-include
# out; its setup.sh links the target's own /usr/include ones).
filc_cross_os_include() {
  local inc="$XROOT/usr/$CROSS/include" d
  rm -rf pizfix/os-include
  mkdir -p pizfix/os-include
  for d in linux asm asm-generic; do ln -s "$inc/$d" "pizfix/os-include/$d"; done
}

# The crt portion of a foreign arch: compiler-rt checks its warning flags with the C++
# compiler and passes them to C too, so both are the host clang aimed at the arch (the
# cross GCC behind cc lacks clang's warnings). A build configured with another C
# compiler is redone, as configure_cmake_project.sh reconfigures only for new options.
filc_cross_compiler_rt() {
  local cache=compiler-rt/build/CMakeCache.txt
  if [ -f "$cache" ] \
      && ! grep -qx "CMAKE_C_COMPILER:FILEPATH=$BUILD_DIR/.filc-cross/bin/clang" "$cache"; then
    rm -rf compiler-rt/build
  fi
  CC=clang CXX=clang++ bash ./build_compiler_rt.sh
}

# ---------- from-source: runtime + libc ----------
# libpas: on a single core, make -j hits a gen-order race where filc_native_forwarders.c
# compiles before the generated filc_native.h exists. Run the script; if it trips that
# race, generate the header and resume make (do NOT re-run the script -- its clean.sh
# would delete the header again).
filc_build_pas() {
  if ! bash ./build_runtime.sh; then
    echo "runtime: filc_native.h gen-order race -> generating header and resuming make"
    ( cd libpas
      ruby src/libpas/generate_pizlonated_forwarders.rb src/libpas/filc_native.h
      . ./common.sh
      "$MAKE" -f Makefile -j "${NCPU:-1}" )
  fi
}

# glibc's install writes the linker scripts in <pizfix>/lib (libc.so) with the absolute
# paths of the build folder it ran in, which exist on no other machine (and in no copy of
# that pizfix/). ld also looks a bare file name up in its library path, where the Fil-C
# driver puts <pizfix>/lib, so the scripts name their libraries bare.
filc_relocate_ld_scripts() {   # $1 = pizfix dir
  local f line
  for f in "$1"/lib/*.so; do
    [ -f "$f" ] && [ ! -L "$f" ] || continue
    # The first line, read without a pipe (pipefail would fail on grep -q leaving early).
    IFS= read -r line < "$f" || true
    # glibc's own scripts start with that comment; fix_yolo_glibc.sh's (libyoloc.so,
    # libyolom.so) start with their first command.
    case "$line" in *"GNU ld script"*|OUTPUT_FORMAT*|GROUP*|INPUT*) ;; *) continue ;; esac
    sed -i -E '/^[[:space:]]*(GROUP|INPUT)/ s#/[^ ()]*/##g' "$f"
  done
}

# Prints, for <path> (cleaned, symlinks kept), its part below the last pizfix/ folder in
# it ("/lib" for .../build/bin/../../pizfix/lib), or below /opt/fil (an optfil package
# laid out as pizfix/ by filc_optfil_to_tree), or nothing when it has neither.
filc_pizfix_sub() {   # $1 = path
  local p
  p="$(realpath -m -s "$1")"
  case "$p" in
    /opt/fil) echo "/" ;;
    /opt/fil/*) echo "/${p#/opt/fil/}" ;;
    */pizfix) echo "/" ;;
    */pizfix/*) echo "/${p##*/pizfix/}" ;;
  esac
}

# The binaries (libraries, programs, iconv modules) in <pizfix dir>.
filc_pizfix_binaries() {   # $1 = pizfix dir
  find "$1" -type f \( -path "*/lib/*" -o -path "*/bin/*" -o -path "*/sbin/*" \
    -o -path "*/libexec/*" \) ! -name '*.a' ! -name '*.o' ! -name '*.h' -print0
}

# Makes every RUNPATH (or RPATH) in <pizfix dir> relative to the binary that holds it.
# The Fil-C driver writes in the absolute pizfix/lib of the toolchain that links; an
# entry below a pizfix/ folder becomes $ORIGIN followed by the path from the binary's
# folder to the same place in <pizfix dir>, which the loader resolves from where the
# binary is, so the libraries find each other wherever pizfix/ is put.
filc_relocate_runpaths() {   # $1 = pizfix dir
  local root f dir rp rest entry sub new
  root="$(cd "$1" && pwd)"
  while IFS= read -r -d '' f; do
    rp="$(patchelf --print-rpath "$f" 2>/dev/null)" || continue
    [ -n "$rp" ] || continue
    dir="$(dirname "$f")"
    new=""
    rest="$rp:"
    while [ -n "$rest" ]; do
      entry="${rest%%:*}"
      rest="${rest#*:}"
      case "$entry" in
        /*)
          sub="$(filc_pizfix_sub "$entry")"
          if [ -n "$sub" ]; then
            entry="$(realpath -m -s --relative-to="$dir" "$root$sub")"
            if [ "$entry" = . ]; then entry='$ORIGIN'; else entry="\$ORIGIN/$entry"; fi
          fi ;;
      esac
      new="${new:+$new:}$entry"
    done
    [ "$new" = "$rp" ] || patchelf --set-rpath "$new" "$f"
  done < <(filc_pizfix_binaries "$1")
}

# Points every program in <pizfix dir> at the loader of that pizfix/: an interpreter must
# be an absolute path (the kernel reads it before any code runs), so it is set where the
# toolchain is put, from where that is, not from where it was built.
filc_set_interpreters() {   # $1 = pizfix dir
  local root f interp sub
  root="$(cd "$1" && pwd)"
  while IFS= read -r -d '' f; do
    interp="$(patchelf --print-interpreter "$f" 2>/dev/null)" || continue
    sub="$(filc_pizfix_sub "$interp")"
    [ -n "$sub" ] && [ -e "$root$sub" ] && [ "$interp" != "$root$sub" ] || continue
    patchelf --set-interpreter "$root$sub" "$f"
  done < <(filc_pizfix_binaries "$1")
}

# The libc portion of --musl: the user musl, its RUNPATHs made relocatable.
filc_build_user_musl() {
  bash ./build_usermusl.sh
  filc_relocate_runpaths pizfix
}

# The libc portion: the user glibc, its linker scripts and RUNPATHs made relocatable.
filc_build_user_glibc() {
  bash ./build_user_glibc.sh
  filc_relocate_ld_scripts pizfix
  filc_relocate_runpaths pizfix
}

# The target triple the Fil-C clang of the current arch names (its getTripleString()),
# under which it finds libc++'s __config_site: <bin>/../include/<triple>/c++/v1.
filc_cxx_triple() {
  echo "$ARCH-unknown-linux-gnu"
}

# Tells whether the build folder holds libc++ whole: its libraries in pizfix/lib and its
# headers beside the clang that compiles with them (build/include).
filc_cxx_built() {
  [ -e "$BUILD_DIR/pizfix/lib/libc++.so" ] \
    && [ -e "$BUILD_DIR/build/include/c++/v1/vector" ] \
    && [ -e "$BUILD_DIR/build/include/$(filc_cxx_triple)/c++/v1/__config_site" ]
}

# The cxx portion: libc++ and libc++abi, compiled by the Fil-C clang of the current arch
# against the pizfix/ runtime and libc built before them, as build_cxx.sh does in
# upstream's LLVM build (configure_llvm.sh's options, glibc flavour), but as a standalone
# runtimes build in cxx-build/, so it needs no LLVM build of the arch's own. Installs the
# libraries into pizfix/lib (as install-cxx-linux.sh) and the headers into build/include,
# where the driver looks for them.
filc_build_cxx() {
  local triple dir="$BUILD_DIR/cxx-build" inst="$BUILD_DIR/cxx-install" ncpu lib f
  triple="$(filc_cxx_triple)"
  ncpu="$(filc_ncpu)"
  # A reused runtime may predate filc_build_user_glibc.
  filc_relocate_ld_scripts "$BUILD_DIR/pizfix"
  local -a cross=() libc_flags=()
  if [ -n "${CROSS:-}" ]; then
    cross=(-DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR="$ARCH"
           -DCMAKE_C_COMPILER_TARGET="$triple" -DCMAKE_CXX_COMPILER_TARGET="$triple")
  fi
  # configure_llvm.sh's default libc option, which setup_glibc.sh empties for glibc.
  case "${LIBC:-glibc}" in
    musl)  libc_flags=(-DLIBCXX_HAS_MUSL_LIBC=ON) ;;
  esac
  mkdir -p "$dir"
  # The compiler checks link a test program, and the Fil-C clang++ links libc++ into
  # every program: before the first libc++ exists they fail, so they are skipped, as in
  # a runtimes bootstrap (libc++'s own checks link with -nostdlib++).
  cmake -S "$BUILD_DIR/compiler/runtimes" -B "$dir" -G Ninja \
    -DCMAKE_C_COMPILER_WORKS=ON -DCMAKE_CXX_COMPILER_WORKS=ON \
    -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi" \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_C_COMPILER="$BUILD_DIR/build/bin/clang" \
    -DCMAKE_CXX_COMPILER="$BUILD_DIR/build/bin/clang++" \
    -DCMAKE_INSTALL_PREFIX="$inst" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="$triple" -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON \
    -DLIBCXXABI_HAS_PTHREAD_API=ON -DLIBCXX_HAS_PTHREAD_API=ON \
    -DLIBCXX_ENABLE_EXCEPTIONS=ON -DLIBCXXABI_ENABLE_EXCEPTIONS=ON \
    -DLIBCXXABI_USE_LLVM_UNWINDER=OFF \
    -DLIBCXX_INCLUDE_TESTS=OFF -DLIBCXXABI_INCLUDE_TESTS=OFF \
    -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
    "${libc_flags[@]}" "${cross[@]}"
  ninja -C "$dir" -j "$ncpu" install-cxx install-cxxabi
  mkdir -p "$BUILD_DIR/build/include"
  rm -rf "$BUILD_DIR/build/include/c++" "$BUILD_DIR/build/include/$triple"
  cp -a "$inst/include/c++" "$BUILD_DIR/build/include/"
  cp -a "$inst/include/$triple" "$BUILD_DIR/build/include/"
  lib="$inst/lib/$triple"
  mkdir -p "$BUILD_DIR/pizfix/lib"
  for f in libc++.so libc++.so.1.0 libc++abi.so.1.0 libc++.a libc++abi.a libc++experimental.a; do
    cp -a "$lib/$f" "$BUILD_DIR/pizfix/lib/"
  done
  ( cd "$BUILD_DIR/pizfix/lib" \
    && ln -sfn libc++.so.1.0 libc++.so.1 \
    && ln -sfn libc++abi.so.1.0 libc++abi.so.1 \
    && ln -sfn libc++abi.so.1 libc++abi.so )
  filc_relocate_runpaths "$BUILD_DIR/pizfix"
}

# Exports what the runtime portions build with: TMPDIR, the host clang, bison's data
# files, and for a foreign arch the cross tools.
filc_runtime_env() {
  [ -x "$BUILD_DIR/build/bin/clang" ] || { echo "ERROR: no clang at $BUILD_DIR/build/bin/clang" >&2; exit 1; }
  export TMPDIR="$BUILD_DIR/tmp-build"; mkdir -p "$TMPDIR"
  export HOST_CLANG
  if [ -f "$TOOLS/bison-share/m4sugar/m4sugar.m4" ]; then
    export BISON_PKGDATADIR="$TOOLS/bison-share"
  fi
  if [ -n "${CROSS:-}" ]; then filc_cross_tools; fi
}

# Builds the runtime and libc layers into pizfix/ (build_base.sh minus its two clang
# steps), then libc++ unless no-cxx is asked: the default build keeps the prebuilt
# toolchain's, as its sources are the compiler/ repo's, not this tree's.
filc_build_runtime_libc() {   # [$1 = no-cxx]
  filc_runtime_env
  local osinc="bash ./build_os_include.sh" crt="bash ./build_compiler_rt.sh"
  if [ -n "${CROSS:-}" ]; then
    osinc=filc_cross_os_include
    crt=filc_cross_compiler_rt
  fi
  # shellcheck disable=SC2086
  filc_portion crt    $crt
  filc_portion unwind bash ./build_yolounwind.sh
  # shellcheck disable=SC2086
  filc_portion osinc  $osinc
  if [ "${LIBC:-glibc}" = musl ]; then
    filc_portion yolo bash ./build_yolomusl.sh
    filc_portion pas  filc_build_pas
    filc_portion libc filc_build_user_musl
  else
    filc_portion yolo bash ./build_yolo_glibc.sh
    filc_portion pas  filc_build_pas
    filc_portion libc filc_build_user_glibc
  fi
  [ "${1:-}" = no-cxx ] || filc_portion cxx filc_build_cxx
  echo "Build complete. Runtime + libc are in $BUILD_DIR/pizfix/lib :"
  ls -1 "$BUILD_DIR/pizfix/lib/libpizlo.so" "$BUILD_DIR"/pizfix/lib/libc.so* 2>/dev/null || true
}

# ---------- pack the built toolchain ----------
# Fails, saying why, unless dist/<name> was written by this run (newer than <marker>), is
# not empty, and passes `xz -t`; nothing is published from a failed pack.
filc_check_archive() {   # $1 = package name, $2 = marker file of the run's start
  local out="$DIST/$1"
  if [ ! -s "$out" ]; then
    echo "ERROR: $out was not created; not publishing." >&2; return 1
  fi
  if [ ! "$out" -nt "$2" ]; then
    echo "ERROR: $out predates this run; not publishing it." >&2; return 1
  fi
  if ! xz -t "$out" 2>/dev/null; then
    echo "ERROR: $out fails xz -t; not publishing." >&2; return 1
  fi
}

# ---------- publish the archive ----------
# Prints the clang that describes the archives: the build folder's, else the tree's. It
# runs here: for a foreign arch it is the host clang that compiled its runtime (see
# filc_cross_helper), of the same Fil-C version.
filc_built_clang() {
  if [ -x "$BUILD_DIR/build/bin/clang-$CLANGVER" ]; then
    echo "$BUILD_DIR/build/bin/clang-$CLANGVER"
  else
    echo "$ROOT/build/bin/clang-$CLANGVER"
  fi
}

# Prints the clang an archive of the current arch holds: the build folder's (see
# filc_clang_dir), else, for the host's arch, the tree's; nothing for a foreign arch not
# built here.
filc_archived_clang() {
  local clang
  clang="$(filc_clang_dir)/bin/clang-$CLANGVER"
  if [ -f "$clang" ]; then echo "$clang"; elif [ -z "${CROSS:-}" ]; then filc_built_clang; fi
}

# Prints the description of the package <name>, for the release text: which hosts it is
# for (its name ends in their arch), its libc, and, for a musl one, the oldest host glibc
# its clang runs on (see filc_archived_clang).
filc_asset_description() {   # $1 = package name
  local arch="${1%.xz}" clang floor=""
  arch="${arch##*-}"
  case "$1" in
    optfil-*.xz)
      printf 'Linux %s, glibc, installed at /opt/fil (sudo ./setup.sh --unattended); its clang runs on its own glibc\n' "$arch"
      return 0 ;;
    filc-*-linux-*.xz)
      clang="$(filc_archived_clang)"
      [ -z "$clang" ] || floor="$(filc_clang_glibc_floor "$clang")"
      printf 'Linux %s, musl, usable wherever it is unpacked (./setup.sh)%s\n' "$arch" \
        "${floor:+; its clang runs on a host glibc >= $floor}"
      return 0 ;;
    *) printf 'Linux %s\n' "$arch" ;;
  esac
}

# Regenerates the release's name (both versions) and text from all
# of its assets, and updates the release when they differ, so the page always says what
# the scripts know. An asset is described by the description given for it (the one just
# published), else by its line in the current text, else by an old label that is not
# its name, else by its name.
FILC_PAGE_PY='
import json, os, re, sys
rel = json.load(sys.stdin)
ver = sys.argv[1]
light = os.environ.get("FILC_LIGHT_VERSION", "")
given = dict(zip(sys.argv[2::2], sys.argv[3::2]))
listed = dict(re.findall(r"^- `([^`]+)`: (.*)$", rel.get("body") or "", re.M))
def describe(asset):
    if asset["name"] in given:
        return given[asset["name"]]
    if asset["name"] in listed:
        return listed[asset["name"]]
    if asset.get("label") and asset["label"] != asset["name"]:
        return asset["label"]
    tag = re.sub(r"^(optfil|filc)-([0-9.]+-)?", "", asset["name"][:-len(".xz")])
    words = tag.replace("-", " ")
    return words[:1].upper() + words[1:]
assets = sorted((a for a in rel.get("assets", []) if a["name"].endswith(".xz")),
                key=lambda a: a["name"])
# The naming, the same as the "Release Naming" section of the compiler repo'"'"'s README.md:
# in full on the latest release, a link to that section on an older one.
naming = "\n".join([
    "We reuse upstream'"'"'s naming where possible:",
    "",
    "- **`optfil-*`** is the prefix for `glibc` compiled binaries, which will be installed"
    " to `/opt/fil` directory (portable: the install into the fixed path is optional).",
    "- **`filc-*`** means `musl` as libc (portable).",
])
if os.environ.get("FILC_RELEASE_LATEST") != "1":
    naming = "See [Release Naming](%s) for what the package names mean." % os.environ.get("FILC_NAMING_URL", "")
body = "\n\n".join([
    "Prebuilt Fil-C-Light %s toolchain packages, based on upstream Fil-C %s." % (light, ver),
    "Assets:\n" + "\n".join("- `%s`: %s" % (a["name"], describe(a)) for a in assets),
    naming,
])
name = "Fil-C-Light %s (upstream %s)" % (light, ver)
if rel.get("body") == body and rel.get("name") == name:
    sys.exit(0)
print(json.dumps({"name": name, "body": body}))
'

# Prepares a GitHub API session for the compiler/ submodule's repo: sets SLUG, VER (the
# upstream release this tree is based on, see filc_upstream_version), API, and HDR (a
# private header file holding the
# token, never put on a command line). Returns 1, saying why, when publishing is not
# possible; filc_github_end removes the header file.
filc_github_begin() {
  local token
  SLUG="$(filc_compiler_repo_slug)"
  if [ -z "$SLUG" ]; then echo "publish: compiler/ is not on GitHub; skipping."; return 1; fi
  token="${FILC_LIGHT_GITHUB_TOKEN:-$(filc_github_token "$SLUG")}"
  if [ -z "$token" ]; then
    echo "publish: no git remote of $SLUG carries an access token; skipping."
    return 1
  fi
  # The release is named after the upstream release this tree is based on, as its
  # packages are (see filc_upstream_version).
  VER="$(filc_upstream_version)"
  API="https://api.github.com/repos/$SLUG"
  HDR="$(mktemp)"
  chmod 600 "$HDR"
  printf 'Authorization: token %s\nAccept: application/vnd.github+json\n' "$token" > "$HDR"
}

filc_github_end() {
  rm -f "$HDR"
}

# Regenerates the name and text of the release v<VER> from all of its assets, with the
# description given for the asset <name>; needs a session from filc_github_begin.
filc_publish_page() {   # [$1 = asset name, $2 = its description]
  local rel id patch latest
  rel="$(curl -sS -H @"$HDR" "$API/releases/tags/v$VER")"
  id="$(printf '%s' "$rel" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("id", ""))')"
  if [ -z "$id" ]; then echo "publish: no release v$VER on $SLUG yet" >&2; return 1; fi
  # The latest release carries the naming in full; an older one links to the README.
  latest="$(curl -sS -H @"$HDR" "$API/releases/latest" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tag_name", ""))' 2>/dev/null)"
  patch="$(printf '%s' "$rel" | FILC_LIGHT_VERSION="$(filc_light_version)" \
    FILC_RELEASE_LATEST="$([ "$latest" = "v$VER" ] && echo 1 || echo 0)" \
    FILC_NAMING_URL="https://github.com/$SLUG#release-naming" \
    python3 -c "$FILC_PAGE_PY" "$VER" "$@")"
  if [ -z "$patch" ]; then
    echo "publish: the text of https://github.com/$SLUG/releases/tag/v$VER is up to date."
    return 0
  fi
  printf '%s' "$patch" | curl -sS -f -H @"$HDR" -X PATCH --data-binary @- -o /dev/null "$API/releases/$id" \
    || { echo "publish: cannot update the release text of v$VER" >&2; return 1; }
  echo "publish: regenerated the name and text of https://github.com/$SLUG/releases/tag/v$VER"
}

# Publishes dist/<name> (an upstream-named package) on the release v<upstream version> of
# the compiler/ submodule's GitHub repo, where filc_download_toolchain fetches it from: creates that
# release (marked latest) when missing, keeps an identical asset, replaces an older one
# of the same name, then regenerates the release's name and text, where its description
# goes. Its label is its file name, which GitHub shows in place of the name. Without a
# token (see filc_github_token) it skips publishing and says so.
filc_upload_archive() {   # $1 = package name
  local name="$1" file rel id asset description sum q
  file="$DIST/$name"
  [ -f "$file" ] || { echo "publish: no $file" >&2; return 1; }
  filc_github_begin || return 0
  description="$(filc_asset_description "$1")"
  rel="$(curl -sS -H @"$HDR" "$API/releases/tags/v$VER")"
  id="$(printf '%s' "$rel" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("id", ""))')"
  if [ -z "$id" ]; then
    echo "publish: creating release v$VER on $SLUG ..."
    rel="$(python3 -c 'import json,sys; print(json.dumps({"tag_name": sys.argv[1], "make_latest": "true"}))' "v$VER" \
           | curl -sS -H @"$HDR" -X POST --data-binary @- "$API/releases")"
    id="$(printf '%s' "$rel" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("id", ""))')"
    if [ -z "$id" ]; then filc_github_end; echo "publish: cannot create release v$VER" >&2; return 1; fi
  fi
  asset="$(printf '%s' "$rel" | python3 -c '
import json, sys
found = [a for a in json.load(sys.stdin).get("assets", []) if a["name"] == sys.argv[1]]
print("%s %s" % (found[0]["id"], found[0].get("digest") or "-") if found else "")' "$name")"
  sum="sha256:$(sha256sum "$file" | cut -d' ' -f1)"
  if [ -n "$asset" ] && [ "${asset#* }" = "$sum" ]; then
    echo "publish: $name is already published on v$VER (same sha256); updating its label only."
    python3 -c 'import json,sys; print(json.dumps({"label": sys.argv[1]}))' "$name" \
      | curl -sS -f -H @"$HDR" -X PATCH --data-binary @- -o /dev/null \
             "$API/releases/assets/${asset%% *}" \
      || { filc_github_end; echo "publish: cannot label $name" >&2; return 1; }
  else
    if [ -n "$asset" ]; then
      echo "publish: replacing the older $name on v$VER ..."
      curl -sS -f -H @"$HDR" -X DELETE "$API/releases/assets/${asset%% *}" \
        || { filc_github_end; echo "publish: cannot delete the older $name" >&2; return 1; }
    fi
    echo "publish: $name -> $SLUG v$VER ..."
    q="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.urlencode({"name": sys.argv[1], "label": sys.argv[1]}))' "$name")"
    curl -sS -f -H @"$HDR" -H "Content-Type: application/x-xz" --data-binary @"$file" \
         -o /dev/null "https://uploads.github.com/repos/$SLUG/releases/$id/assets?$q" \
      || { filc_github_end; echo "publish: upload of $name failed" >&2; return 1; }
    echo "publish: published https://github.com/$SLUG/releases/download/v$VER/$name"
  fi
  filc_publish_page "$name" "$description" || { filc_github_end; return 1; }
  filc_github_end
}

# ---------- /opt/fil: the glibc toolchain installed the way upstream's optfil/ does ----------
# Prints a warning on stderr, the way XD's build-handler.sh (bh_warning) lays it out: a
# blank line, "WARNING:" (bold on a terminal) and the first line, each further line
# under the message column, and a blank line.
filc_warning() {   # $1 = first line, $2... = further lines
  [ "$#" -gt 0 ] || return 0
  local b="" r="" line
  if [ -t 2 ]; then
    b="$(printf '\033[1m')"
    r="$(printf '\033[22m')"
  fi
  printf '\n%sWARNING:%s %s\n' "$b" "$r" "$1" >&2
  shift
  for line in "$@"; do
    printf '         %s\n' "$line" >&2
  done
  printf '\n' >&2
}

# Gets root for --install (sudo), asking for the password up front, as a build takes
# hours, and keeps sudo's timestamp fresh until the run ends (FILC_SUDO_KEEPALIVE).
# Under --headless it asks nothing: without a password at hand it warns, and turns
# --install off for this run.
filc_optfil_root() {
  if [ -n "$HEADLESS" ]; then
    if ! sudo -n true 2>/dev/null; then
      filc_warning "No root password at hand (--headless), so /opt/fil is left alone:" \
        "the glibc toolchain stays in $HOST_BUILD_DIR (and this tree, $ROOT)" \
        "instead of /opt/fil, and finds its paths at run time."
      INSTALL=0
      return 0
    fi
  else
    echo "Installing the toolchain at /opt/fil needs root (--no-install leaves /opt/fil alone):"
    sudo -v || { echo "ERROR: no root, so the toolchain cannot be installed at /opt/fil." >&2; exit 1; }
  fi
  ( while sleep 60; do sudo -n true 2>/dev/null || exit 0; done ) &
  FILC_SUDO_KEEPALIVE=$!
}

# Writes the upstream release this tree is based on (see filc_upstream_version) into the
# build folder's copy of upstream's optfil/ scripts, which spell their own version out
# (the package's name in build_finish.sh, VERSION in setup.sh).
filc_optfil_set_version() {
  local ver
  if [ ! -f "$BUILD_DIR/optfil/build_opt.sh" ]; then
    echo "ERROR: optfil/ (upstream's /opt/fil scripts, trimmed for Fil-C-Light) is missing" \
         "from $ROOT; it is git-ignored, so copy it into the tree first." >&2
    exit 1
  fi
  ver="$(filc_upstream_version)"
  sed -i -E "s/^package_name=optfil-[0-9.]+-/package_name=optfil-$ver-/" "$BUILD_DIR/optfil/build_finish.sh"
  sed -i -E "s/^VERSION=\"[0-9.]+\"/VERSION=\"$ver\"/" "$BUILD_DIR/optfil/setup.sh"
}

# Prints the environment optfil's scripts build with, as NAME=VALUE words: bison's data
# files when this tree fetched them (see filc_install_bison), as the runtime's portions
# get them (sudo starts from a clean environment).
filc_optfil_env() {
  if [ -f "$TOOLS/bison-share/m4sugar/m4sugar.m4" ]; then
    echo "BISON_PKGDATADIR=$TOOLS/bison-share"
  fi
}

# Installs the toolchain the build folder built (the bootstrap) at /opt/fil, exactly as
# upstream's optfil/ does it: build_opt.sh builds both glibcs again for the /opt/fil
# prefix, as root, straight into /opt/fil (emptied first), and puts the clang, the
# runtime and libc++ next to them; build_package.sh strips it and packs it with its
# setup.sh and licenses (build_finish.sh), see filc_optfil_dist. Only for this machine's
# arch: a foreign one cannot run here (see filc_optfil_package).
filc_optfil_install() {   # $1 = marker file of the run's start
  echo "===== optfil: installing the toolchain at /opt/fil (its old content is replaced) ====="
  sudo mkdir -p /opt/fil
  filc_optfil_set_version
  ( cd "$BUILD_DIR/optfil" && sudo env $(filc_optfil_env) ./build_opt.sh )
  filc_light_stamp "$TOOLS/stamp" glibc
  sudo mkdir -p /opt/fil/share
  sudo cp "$TOOLS/stamp/share/fil-c-light.ini" /opt/fil/share/fil-c-light.ini
  rm -rf "$TOOLS/stamp"
  if [ -n "$NOXZ" ]; then
    echo "(--no-xz: /opt/fil is not packed)"
    return 0
  fi
  ( cd "$BUILD_DIR/optfil" && sudo ./build_package.sh )
  filc_optfil_dist "$1"
}

# Builds the same /opt/fil toolchain as filc_optfil_install, but under the build folder's
# optfil-root/ instead of the real /opt/fil, needing no root (OPTFIL_DESTDIR, see
# optfil/build_opt.sh), and packs it: for a foreign arch, which this machine cannot
# install, and for this one under --no-install. The glibcs are still configured for
# /opt/fil; the user glibc is compiled by the build folder's clang (aimed at the arch).
filc_optfil_package() {   # $1 = marker file of the run's start
  echo "===== optfil: building the $ARCH toolchain for /opt/fil (not installed here) ====="
  filc_optfil_set_version
  ( cd "$BUILD_DIR/optfil"
    if [ -n "$CROSS" ]; then filc_cross_env; fi
    optfil_env="$(filc_optfil_env)"
    # shellcheck disable=SC2086
    [ -z "$optfil_env" ] || export $optfil_env
    export OPTFIL_DESTDIR="$BUILD_DIR/optfil-root"
    export OPTFIL_FILCC="$BUILD_DIR/build/bin/clang" OPTFIL_FILCXX="$BUILD_DIR/build/bin/clang++"
    export OPTFIL_CLANG
    OPTFIL_CLANG="$(filc_clang_dir)/bin/clang-$CLANGVER"
    ./build_opt.sh
    filc_light_stamp "$OPTFIL_DESTDIR/opt/fil" glibc
    if [ -z "$NOXZ" ]; then ./build_package.sh; fi )
  if [ -n "$NOXZ" ]; then
    echo "(--no-xz: the $ARCH /opt/fil toolchain is not packed)"
    return 0
  fi
  filc_optfil_dist "$1"
}

# Prints the libc of the toolchain in <dir> (its build/ + pizfix/) as package-build.sh
# tells it: glibc when pizfix/lib holds libc.so.6666, else musl.
filc_toolchain_libc() {   # $1 = dir
  if [ -f "$1/pizfix/lib/libc.so.6666" ]; then echo glibc
  else echo musl; fi
}

# Packs the toolchain in <dir> (default: the build folder) the way upstream's binary
# package is made: its package-build.sh, run there, puts build/ (the clang, libc++'s
# headers, the Fil-C-Light marker), pizfix/, its setup.sh (which points every binary at
# where it is unpacked), the licenses and the README into <base>-<version>-linux-<arch>
# (filc for musl; it refuses glibc, whose package is the /opt/fil
# one), which lands in dist/ as <base>-<version>-linux-<arch>.xz and is published with
# --publish.
filc_upstream_package() {   # $1 = marker file of the run's start, [$2 = dir]
  local dir="${2:-$BUILD_DIR}" libc name made
  libc="$(filc_toolchain_libc "$dir")"
  echo "===== $libc: packing the $ARCH toolchain of $dir (upstream's package-build.sh) ====="
  ( cd "$dir"
    if [ -n "$CROSS" ]; then filc_cross_env; fi
    export PACKAGE_VERSION
    PACKAGE_VERSION="$(filc_upstream_version)"
    if [ "$dir" = "$BUILD_DIR" ]; then
      export PACKAGE_CLANG
      PACKAGE_CLANG="$(filc_clang_dir)/bin/clang-$CLANGVER"
    fi
    rm -rf filc-*-"$ARCH" filc-*-"$ARCH".xz
    filc_light_stamp build "$libc"
    bash ./3rd-party/builds/package-build.sh ) || exit 1
  made="$(ls -t "$dir"/filc-*-"$ARCH".xz 2>/dev/null | head -1)"
  [ -n "$made" ] || { echo "ERROR: package-build.sh made no package in $dir" >&2; exit 1; }
  name="${made##*/}"
  mkdir -p "$DIST"
  mv -f "$made" "$DIST/$name"
  rm -rf "${made%.xz}"
  echo "archive: $DIST/$name ($(du -h "$DIST/$name" | cut -f1))"
  filc_check_archive "$name" "$1" || exit 1
  [ "$PUBLISH" != 1 ] || filc_upload_archive "$name"
}

# Moves the package build_finish.sh made into dist/ as optfil-<version>-linux-<arch>.xz,
# and publishes it with --publish.
filc_optfil_dist() {   # $1 = marker file of the run's start
  local ver name made
  ver="$(filc_upstream_version)"
  name="optfil-$ver-linux-$ARCH.xz"
  made="$(ls -t "$BUILD_DIR"/optfil/optfil-*-"$ARCH".xz 2>/dev/null | head -1)"
  [ -n "$made" ] || { echo "ERROR: build_finish.sh made no optfil-*-$ARCH.xz" >&2; exit 1; }
  mkdir -p "$DIST"
  mv -f "$made" "$DIST/$name"
  echo "archive: $DIST/$name ($(du -h "$DIST/$name" | cut -f1))"
  filc_check_archive "$name" "$1" || exit 1
  [ "$PUBLISH" != 1 ] || filc_upload_archive "$name"
}

# ---------- prerequisites ----------
filc_install_bison() {
  if [ -f "$TOOLS/bison-share/m4sugar/m4sugar.m4" ]; then
    echo "bison data already present under $TOOLS/bison-share"; return
  fi
  command -v bison >/dev/null || { echo "ERROR: no 'bison' binary on PATH." >&2; exit 1; }
  echo "Fetching bison data files (skeletons + m4sugar) ..."
  mkdir -p "$TOOLS/deb"
  ( cd "$TOOLS/deb" && apt-get download bison )
  dpkg-deb -x "$TOOLS"/deb/bison_*.deb "$TOOLS/deb/x"
  cp -a "$TOOLS/deb/x/usr/share/bison" "$TOOLS/bison-share"
  rm -rf "$TOOLS/deb"
  echo "bison data installed at $TOOLS/bison-share"
}

# ---------- driver ----------
filc_usage() {
  echo "usage: $0 [--nightly|--latest] [--universal|--static|--general]" \
       "[--no-universal|--no-static|--non-universal|--non-static] [--sync[=<re>]]" \
       "[--no-sync] [--clean[=<re>]] [--rebuild[=<re>]] [-d <dir>|--directory=<dir>]" \
       "[--no-xz|--no-archive]" \
       "[--no-publish|--no-upload] [--publish|--upload] [--no-build|--no-rebuild]" \
       "[--export] [--prerequisites] [--archs=<list>|--arch=<list>]" \
       "[--glibc|--gnu|--musl] [--install|--setup|--no-install|--no-setup] [--headless]" >&2
  exit 2
}

# Sets MODE, STATIC, NOXZ, PUBLISH, SYNC, FILC_SYNC_FILTER, FILC_CLEAN_FILTER, ARCHS,
# LIBC, INSTALL, HEADLESS and BUILD_DIR from the arguments, in order: a later flag
# overrides an earlier one. MODE is light (the default: build this tree with the
# prebuilt clang), source (build everything), download (fetch only), clean (clean
# only), export, upload (publish dist/ without building) or prerequisites.
filc_parse_args() {
  MODE=light
  STATIC=""
  NOXZ=""
  PUBLISH=0          # publishing is asked for
  SYNC=1             # the tree's toolchain is updated once the build is done
  FILC_SYNC_FILTER=""
  FILC_CLEAN_FILTER=""
  ARCHS="$(filc_host_arch)"
  LIBC=glibc         # the libc slice
  INSTALL=1          # with glibc: install the toolchain at /opt/fil
  HEADLESS=""        # never ask anything
  local asked_publish="" asked_build="" nobuild=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --nightly|--latest)   MODE=source; asked_build=1; nobuild="" ;;
      ""|--build)           MODE=light; asked_build=1; nobuild="" ;;
      --universal|--static|--general) STATIC=static ;;
      --no-universal|--no-static|--non-universal|--non-static) STATIC="" ;;
      --no-build|--no-rebuild) nobuild=1 ;;
      --sync)               SYNC=1; FILC_SYNC_FILTER='^.*$' ;;
      --sync=*)             SYNC=1; FILC_SYNC_FILTER="${1#--sync=}"; [ -n "$FILC_SYNC_FILTER" ] || FILC_SYNC_FILTER='^.*$' ;;
      --no-sync)            SYNC=0; FILC_SYNC_FILTER="" ;;
      --clean)              FILC_CLEAN_FILTER='^.*$' ;;
      --clean=*)            FILC_CLEAN_FILTER="${1#--clean=}"
                            [ -n "$FILC_CLEAN_FILTER" ] || FILC_CLEAN_FILTER='^.*$' ;;
      # --rebuild is --clean plus a build.
      --rebuild)            asked_build=1; nobuild=""; FILC_CLEAN_FILTER='^.*$' ;;
      --rebuild=*)          asked_build=1; nobuild=""; FILC_CLEAN_FILTER="${1#--rebuild=}"
                            [ -n "$FILC_CLEAN_FILTER" ] || FILC_CLEAN_FILTER='^.*$' ;;
      -d|--directory)
        # A relative value is absolutised: the build cds around before reusing BUILD_DIR.
        [ $# -ge 2 ] || filc_usage
        case "$2" in /*) BUILD_DIR="$2" ;; *) BUILD_DIR="$(pwd)/$2" ;; esac
        shift ;;
      --directory=*)
        case "${1#--directory=}" in /*) BUILD_DIR="${1#--directory=}" ;; *) BUILD_DIR="$(pwd)/${1#--directory=}" ;; esac ;;
      --archs|--arch)
        [ $# -ge 2 ] || filc_usage
        ARCHS="$(filc_parse_archs "$2")" || exit 2
        shift ;;
      --archs=*|--arch=*)   ARCHS="$(filc_parse_archs "${1#*=}")" || exit 2 ;;
      --no-xz|--no-archive) NOXZ=1 ;;
      --no-publish|--no-upload) PUBLISH=0; asked_publish="" ;;
      --export)             MODE=export ;;
      --publish|--upload)   PUBLISH=1; asked_publish=1 ;;
      --prerequisites)      MODE=prerequisites ;;
      --glibc|--gnu)        LIBC=glibc ;;
      --musl)               LIBC=musl ;;
      --install|--setup)    INSTALL=1 ;;
      --no-install|--no-setup) INSTALL=0 ;;
      --headless)           HEADLESS=1 ;;
      -h|--help)            sed -n '2,/^set -euo pipefail$/{/^set -euo/!p}' "${BASH_SOURCE[0]}"; exit 0 ;;
      *) filc_usage ;;
    esac
    shift
  done
  # --no-build: publishing what dist/ already holds with --publish, only cleaning with
  # --clean, else only fetching. --clean alone only cleans; with a build flag or
  # --publish it cleans, then builds (an export never builds).
  if [ -n "$nobuild" ] && [ "$MODE" != export ] && [ "$MODE" != prerequisites ]; then
    if [ -n "$asked_publish" ]; then
      MODE=upload
    elif [ -n "$FILC_CLEAN_FILTER" ]; then
      MODE=clean
    else
      MODE=download
    fi
  elif [ -n "$FILC_CLEAN_FILTER" ] && [ "$MODE" = light ] \
      && [ -z "$asked_build" ] && [ -z "$asked_publish" ]; then
    MODE=clean
  fi
  # Only a build from source builds the clang, so cleaning it asks for one.
  if [ "$MODE" = light ] && filc_clean_filter clang; then MODE=source; fi
  # The build folder sits beside the tree, the way XD's build-handler places its own.
  # A musl build folder sits beside the glibc one, as the two libcs cannot share a pizfix/;
  # it takes the clang the glibc one built (see filc_borrow_clang).
  FILC_GLIBC_BUILD_DIR="$(dirname "$ROOT")/build/$(basename "$ROOT")${FILC_BUILD_DIR_SUFFIX:-}"
  if [ "$LIBC" != glibc ]; then
    : "${BUILD_DIR:=$(dirname "$ROOT")/build/$(basename "$ROOT")-$LIBC${FILC_BUILD_DIR_SUFFIX:-}}"
  fi
  : "${BUILD_DIR:=$FILC_GLIBC_BUILD_DIR}"
}

# Builds the toolchain of the current arch (see filc_use_arch) from source, syncs the
# host's into the tree, then packs and publishes it. A foreign arch first gets its cross
# root and the host clang that compiles its runtime.
filc_build_arch() {   # $1 = marker file of the run's start
  local started="$1"
  BUILT=""
  SYNCED=""
  filc_mirror
  if [ -n "$CROSS" ]; then
    filc_install_cross "$ARCH"
    filc_cross_helper
  fi
  filc_build_clang "$STATIC"
  # Each portion is kept when its sources did not change since it built (the runtime does
  # not depend on how clang links its C++ runtime, so a universal build reuses it too).
  filc_build_runtime_libc
  filc_sync_arch
  filc_pack_arch "$started"
}

# The entire build of the current arch is done: only now does the tree's toolchain
# change, and only by the host's build.
filc_sync_arch() {
  if [ -n "$CROSS" ]; then
    echo "($ARCH is cross-compiled: the tree's toolchain is left as it was; the build is in $BUILD_DIR)"
  elif [ "$SYNC" = 1 ]; then
    filc_sync_all
    [ ! -d "$ROOT/build/bin" ] || filc_light_stamp "$ROOT/build"
  else
    echo "(--no-sync: the tree's toolchain is left as it was; the build is in $BUILD_DIR)"
  fi
}

# Packs the build folder's toolchain as upstream does, unless --no-xz, and publishes it
# with --publish: a --musl one here (see filc_upstream_package); a glibc one is
# the /opt/fil package, which the main loop packs (see filc_optfil_package).
filc_pack_arch() {   # $1 = marker file of the run's start
  if [ -n "$NOXZ" ]; then echo "(--no-xz: skipping archive generation)"; return 0; fi
  [ "$LIBC" = glibc ] || filc_upstream_package "$1"
}

filc_main() {
  BUILT=""
  SYNCED=""
  filc_parse_args "$@"
  HOST_BUILD_DIR="$BUILD_DIR"
  filc_use_arch "$(filc_host_arch)"
  # The run's start, against which a fresh archive is told from an old one; the second
  # of waiting keeps an archive packed right away newer than it on any file system.
  local started=""
  case "$MODE" in
    light|source|export)
      mkdir -p "$TOOLS"
      started="$(mktemp "$TOOLS/.run-start.XXXXXX")"
      # Expanded now: at exit this function's locals are gone.
      # shellcheck disable=SC2064
      trap "rm -f -- '$started'; [ -z \"\${FILC_SUDO_KEEPALIVE:-}\" ] || kill \"\$FILC_SUDO_KEEPALIVE\" 2>/dev/null" EXIT
      sleep 1 ;;
  esac
  local arch
  case "$MODE" in
    prerequisites)
      filc_install_bison
      for arch in $ARCHS; do
        filc_use_arch "$arch"
        [ -z "$CROSS" ] || filc_install_cross "$arch"
      done
      ;;
    clean)
      for arch in $ARCHS; do
        filc_use_arch "$arch"
        filc_clean_all
      done
      ;;
    export)
      # The toolchain in use, packed the way upstream packs one (see filc_upstream_package):
      # the tree's for this machine's arch, the build folder's for a foreign one.
      for arch in $ARCHS; do
        filc_use_arch "$arch"
        if [ -z "$CROSS" ]; then
          [ -x "$ROOT/build/bin/clang-$CLANGVER" ] \
            || { echo "export: no toolchain in $ROOT/build to pack" >&2; exit 1; }
          filc_upstream_package "$started" "$ROOT"
        else
          [ -f "$(filc_clang_dir)/bin/clang-$CLANGVER" ] \
            || { echo "export: no $arch toolchain built in $BUILD_DIR to pack" >&2; exit 1; }
          filc_upstream_package "$started"
        fi
      done
      ;;
    upload)
      local found="" f
      for arch in $ARCHS; do
        filc_use_arch "$arch"
        # The upstream-named packages: optfil-<version>-linux-<arch>.xz (glibc) and
        # filc-<version>-linux-<arch>.xz (musl).
        for f in "$DIST"/optfil-*-linux-"$ARCH".xz "$DIST"/filc-*-linux-"$ARCH".xz; do
          if [ -f "$f" ]; then found=1; filc_upload_archive "$(basename "$f")"; fi
        done
      done
      if [ -z "$found" ]; then
        # No archive to add: the release page alone is regenerated.
        echo "publish: no optfil-*.xz or filc-*.xz package in $DIST; regenerating the release page only."
        filc_use_arch "$(filc_host_arch)"
        if filc_github_begin; then
          filc_publish_page || { filc_github_end; exit 1; }
          filc_github_end
        fi
      fi
      ;;
    download)
      # With --install (and glibc) the prebuilt toolchain goes to /opt/fil, flat, as
      # upstream installs it; with --no-install into the tree (build/ + pizfix/). A
      # foreign arch's toolchain goes to neither.
      case " $ARCHS " in
        *" $(filc_host_arch) "*)
          if [ "$LIBC" = glibc ] && [ "$INSTALL" = 1 ]; then filc_optfil_root; fi ;;
      esac
      for arch in $ARCHS; do
        filc_use_arch "$arch"
        if [ -n "$CROSS" ]; then
          echo "(--no-build: $arch is not this machine's arch; nothing to fetch for it)"
        elif [ "$LIBC" != glibc ]; then
          echo "ERROR: no prebuilt $LIBC toolchain is published (only the glibc one, as the" \
               "optfil package); build it: ./build.sh --$LIBC" >&2
          exit 1
        elif [ "$INSTALL" = 1 ]; then
          filc_download_install || exit 1
        else
          filc_download_toolchain || exit 1
        fi
      done
      ;;
    light|source)
      case " $ARCHS " in
        *" $(filc_host_arch) "*)
          if [ "$LIBC" = glibc ] && [ "$INSTALL" = 1 ]; then filc_optfil_root; fi ;;
      esac
      filc_install_bison
      for arch in $ARCHS; do
        filc_use_arch "$arch"
        if [ "$MODE" = source ]; then
          filc_build_arch "$started"
        elif ! filc_light_arch "$started"; then
          echo ">>> no prebuilt $arch toolchain; building it from source (as --nightly)."
          filc_build_arch "$started"
        fi
        if [ "$LIBC" = glibc ]; then
          if [ -z "$CROSS" ] && [ "$INSTALL" = 1 ]; then
            filc_optfil_install "$started"
          elif [ "$MODE" = source ] || [ "$PUBLISH" = 1 ]; then
            # Packed as any build packs: always by --nightly, by the default one only
            # to publish (it builds both glibcs again, for /opt/fil).
            filc_optfil_package "$started"
          fi
        fi
      done
      ;;
  esac
}

# Runs only when executed; tests/build.spec.sh sources this file for its functions.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  filc_main "$@"
fi
