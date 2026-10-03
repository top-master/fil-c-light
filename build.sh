#!/usr/bin/env bash
#
# Fil-C-Light build driver.
#
# The expensive part of a Fil-C build is compiling LLVM+Clang from source (hours). To
# spare that, this driver defaults to fetching a prebuilt toolchain archive for the host
# platform and only builds from source on request (or when no archive is available).
#
#   ./build.sh                 Fetch + unpack a prebuilt toolchain for this platform:
#                              build/  = the Fil-C clang, pizfix/ = runtime + libc + libc++.
#                              No compilation. Falls back to a from-source build if no
#                              matching archive can be downloaded.
#
#   ./build.sh --nightly       Build the toolchain FROM SOURCE: init the compiler/ submodule
#   ./build.sh --latest        (llvm+clang) if needed, compile clang, then the memory-safe
#                              runtime and the glibc slice. On success the result is packed
#                              into dist/filc-<platform>.xz for reuse/redistribution.
#
#                              A from-source build runs in the build folder beside this
#                              tree (../build/<tree name>, see -d), a mirror of the tree
#                              that upstream's scripts build in unchanged. The tree's own
#                              build/ and pizfix/ (the toolchain in use) are updated once
#                              the ENTIRE build is done (see --sync and --no-sync).
#
#   ./build.sh --universal     The UNIVERSAL build: as --nightly, but link the clang
#   ./build.sh --static        portably (static libstdc++/libgcc; glibc stays dynamic, and
#   ./build.sh --general       is backward compatible) so it runs on any Linux whose glibc
#                              is at least as new as the build host's symbols need; the
#                              runtime in pizfix/ brings its own libc, so it never depends
#                              on the host's. Reuses an existing clang build (a re-link)
#                              and an existing pizfix/ runtime; archived as
#                              dist/filc-linux-universal-<arch>.xz.
#
#   ./build.sh --sync[=<re>]   Also update each portion of the tree's toolchain right after
#                              that portion builds, when its keyword matches the extended
#                              regexp <re> (default: every portion); the others still wait
#                              for the entire build. Keywords: clang (the compiler),
#                              crt (compiler-rt crt objects), unwind (libyolounwind),
#                              osinc (pizfix/os-include), yolo (yolo glibc), pas (libpas
#                              runtime, libpizlo), libc (user glibc). E.g. --sync='clang|pas'.
#   ./build.sh --no-sync       Leave the tree's toolchain as it is, even after the build.
#
#   ./build.sh --clean[=<re>]  Remove the build output that each portion whose keyword
#                              (as for --sync; not a path) matches <re> (default: all)
#                              keeps in the build folder (clang: the whole LLVM build).
#                              Only cleans, unless a build flag or --publish is also
#                              given (then it cleans each portion right before that
#                              portion builds).
#   ./build.sh --rebuild[=<re>]  --clean[=<re>], then a from-source build: the matching
#                              portions build from scratch (clang: hours), and a
#                              universal build rebuilds the runtime instead of reusing it.
#
#   ./build.sh -d <dir>        Use <dir> as the build folder instead of ../build/<tree name>
#   ./build.sh --directory=<dir>  (a relative <dir> is taken from the current directory).
#
#   ./build.sh --no-xz         With a from-source build, skip generating the .xz archive.
#   ./build.sh --no-archive    (alias of --no-xz)
#
#   ./build.sh --export        Only create the .xz archive, from the toolchain this tree
#                              already uses (build/ + pizfix/): no build, no publishing.
#                              Named after its clang's linkage (universal or the distro).
#
#                              A generated archive is then published on the release
#                              v<Fil-C version> of the compiler/ submodule's GitHub repo
#                              (where the default mode downloads it from), when a git
#                              remote of that repo carries an access token in its URL:
#                              the archive becomes a labelled asset, and the release's
#                              name and text are regenerated from all of its assets.
#   ./build.sh --no-publish    With a from-source build, keep the archive local only.
#   ./build.sh --no-upload     (alias of --no-publish)
#   ./build.sh --publish       Publish (the default for a from-source build, so this turns
#   ./build.sh --upload        it back on after --no-publish). With no other flag it builds
#                              from source first. Only an archive this run created, and
#                              that passes `xz -t`, is ever published; a failed build or
#                              export publishes nothing. After --export: publish the export.
#
#   ./build.sh --no-build      With --publish: publish the archives already in dist/,
#   ./build.sh --no-rebuild    without building, and regenerate the release's name and
#                              text (only that, when dist/ holds no archive).
#
#                              Flags take effect in order, so a later one overrides an
#                              earlier one: --no-publish --publish publishes, --sync
#                              --no-sync does not sync.
#
#   ./build.sh --install       Fetch build-only prerequisites that cannot be built from this
#                              tree: the GNU Bison data files (skeletons + m4sugar), in case
#                              the host bison lacks them. Needed before a from-source build.
#
#   ./build.sh -h | --help
#
# Env overrides:
#   BUILD_DIR                The build folder (as -d), default ../build/<tree name>.
#   FILC_BUILD_DIR_SUFFIX    Appended to that default folder's name.
#   FILC_LIGHT_GITHUB_TOKEN  GitHub token for publishing, instead of the one found in the
#                            git remotes (see filc_github_token).
#   FILC_LIGHT_RELEASE_URL   Base URL that hosts the prebuilt filc-<platform>.xz archives.
#                            If unset, it is derived from the 'origin' GitHub remote
#                            (…/releases/latest/download). If neither is available, the
#                            default falls through to a from-source build.
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
# PLAT           distro-specific, dynamically linked -> filc-ubuntu-x86_64.xz
# UNIVERSAL_PLAT portable, static libstdc++/libgcc   -> filc-linux-universal-x86_64.xz
filc_detect_platform() {
  ARCH="$(uname -m)"
  local id=linux
  # In a subshell: os-release defines NAME, VERSION and more, which stay out of this one.
  if [ -r "${FILC_OS_RELEASE:-/etc/os-release}" ]; then
    id="$(. "${FILC_OS_RELEASE:-/etc/os-release}" && echo "${ID:-linux}")"
  fi
  PLAT="${id}-${ARCH}"
  UNIVERSAL_PLAT="linux-universal-${ARCH}"
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

# Base URL for prebuilt archives: explicit env wins, else derive from the compiler repo.
filc_release_base_url() {
  if [ -n "${FILC_LIGHT_RELEASE_URL:-}" ]; then echo "$FILC_LIGHT_RELEASE_URL"; return; fi
  local slug; slug="$(filc_compiler_repo_slug)"
  [ -z "$slug" ] || echo "https://github.com/$slug/releases/latest/download"
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

# ---------- prebuilt fast path ----------
filc_download_toolchain() {
  local base; base="$(filc_release_base_url)"
  if [ -z "$base" ]; then
    echo "No prebuilt-release URL (set FILC_LIGHT_RELEASE_URL or add a GitHub 'origin')."
    return 1
  fi
  mkdir -p "$TOOLS"
  local tag f
  for tag in "$PLAT" "$UNIVERSAL_PLAT"; do        # prefer the exact distro build, then universal
    f="filc-$tag.xz"
    echo "Trying prebuilt $base/$f ..."
    if curl -fL --retry 2 -o "$TOOLS/$f" "$base/$f" 2>/dev/null; then
      echo "Unpacking $f into the tree ..."
      tar -C "$ROOT" -xJf "$TOOLS/$f"
      rm -f "$TOOLS/$f"
      echo "Prebuilt toolchain ready: $("$ROOT/build/bin/clang" --version | head -1)"
      return 0
    fi
  done
  echo "No prebuilt archive available for $PLAT or $UNIVERSAL_PLAT."
  return 1
}

# ---------- the build folder: a mirror of the tree ----------
# Mirrors the tree's sources into the build folder, where upstream's scripts build
# unchanged: the read-only compiler/ sources and filc/ are linked, everything upstream
# writes into is copied (no --delete, so earlier build output there stays incremental).
# A missing pizfix/ there starts as a copy of the tree's, so a portion that is not rebuilt
# still finds the runtime it builds on.
filc_mirror() {
  mkdir -p "$BUILD_DIR"
  rsync -a \
    --exclude=/.git --exclude=/build/ --exclude=/pizfix/ --exclude=/dist/ \
    --exclude=/.filc-light-tools/ --exclude=/tmp-build/ --exclude=/compiler --exclude=/filc \
    "$ROOT/" "$BUILD_DIR/"
  local d
  for d in compiler filc; do
    [ -L "$BUILD_DIR/$d" ] || { rm -rf "${BUILD_DIR:?}/$d"; ln -s "$ROOT/$d" "$BUILD_DIR/$d"; }
  done
  if [ ! -d "$BUILD_DIR/pizfix" ] && [ -d "$ROOT/pizfix" ]; then
    cp -a "$ROOT/pizfix" "$BUILD_DIR/pizfix"
  fi
}

# ---------- cleaning portions (--clean, and --rebuild through it) ----------
FILC_PORTIONS="clang crt unwind osinc yolo pas libc"

# A portion's keyword is cleaned when it matches FILC_CLEAN_FILTER (an extended regexp
# over the keywords, not over paths); an empty filter matches none.
filc_clean_filter() {   # $1 = portion keyword
  [ -n "$FILC_CLEAN_FILTER" ] && printf '%s\n' "$1" | grep -Eq -- "$FILC_CLEAN_FILTER"
}

# Tells whether any runtime portion is to be cleaned.
filc_clean_wants_runtime() {
  local kw
  for kw in $FILC_PORTIONS; do
    [ "$kw" = clang ] && continue
    if filc_clean_filter "$kw"; then return 0; fi
  done
  return 1
}

# Removes the build output a portion keeps in the build folder, so it builds from
# scratch; what it installed into the build folder's pizfix/ stays. osinc keeps none.
filc_clean_portion() {   # $1 = portion keyword
  case "$1" in
    clang)  rm -rf "${BUILD_DIR:?}/build" ;;
    crt)    rm -rf "${BUILD_DIR:?}/compiler-rt/build" ;;
    unwind) rm -f "${BUILD_DIR:?}"/yolounwind/*.o "${BUILD_DIR:?}"/yolounwind/*.a ;;
    yolo)   rm -rf "${BUILD_DIR:?}/pizlonated-yolo-glibc-build" ;;
    pas)    rm -rf "${BUILD_DIR:?}/libpas/build" ;;
    libc)   rm -rf "${BUILD_DIR:?}/pizlonated-user-glibc-build" ;;
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
# empty filter passes none, which is the default until the entire build is done.
filc_sync_filter() {   # $1 = portion keyword
  [ -n "$FILC_SYNC_FILTER" ] && printf '%s\n' "$1" | grep -Eq -- "$FILC_SYNC_FILTER"
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
    *)
      [ -f "$BUILD_DIR/.filc-portions/$1.list" ] || return 0
      while IFS= read -r f; do filc_sync_file "$1" "$f"; done < "$BUILD_DIR/.filc-portions/$1.list"
      ;;
  esac
  if filc_sync_filter "$1"; then SYNCED="$SYNCED $1"; echo "synced: $1"; fi
}

# Runs <command> in the build folder as the portion <keyword>, records the pizfix/ files
# it wrote in that portion's manifest, and syncs it when --sync's filter passes it.
filc_portion() {   # $1 = portion keyword, $2... = command
  local kw="$1" marker
  shift
  if filc_clean_filter "$kw"; then filc_clean_portion "$kw"; fi
  mkdir -p "$BUILD_DIR/.filc-portions"
  marker="$BUILD_DIR/.filc-portions/$kw.start"
  : > "$marker"
  echo "===== $kw: $* ====="
  ( cd "$BUILD_DIR" && "$@" )
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
      *) runtime=1 ;;
    esac
  done
  if [ -n "$runtime" ]; then
    filc_sync_dir runtime pizfix
    echo "synced: the pizfix/ runtime"
  fi
}

# ---------- from-source: the compiler ----------
# Tells whether <clang> (default: the build folder's) links the C++ runtime statically
# (the universal linkage): its dynamic dependencies name no libstdc++ and no libgcc_s.
filc_clang_is_universal() {   # [$1 = clang binary]
  ! readelf -d "${1:-$BUILD_DIR/build/bin/clang-$CLANGVER}" 2>/dev/null \
    | grep -qE 'NEEDED.*(libstdc\+\+|libgcc_s)'
}

# Prints the newest GLIBC symbol version <clang> (default: the build folder's) needs,
# i.e. the oldest glibc it runs on, or nothing when objdump cannot tell.
filc_clang_glibc_floor() {   # [$1 = clang binary]
  objdump -T "${1:-$BUILD_DIR/build/bin/clang-$CLANGVER}" 2>/dev/null \
    | grep -o 'GLIBC_[0-9][0-9.]*' | sed 's/GLIBC_//' | sort -uV | tail -1
}

filc_build_clang() {   # $1 = "static" for the portable universal build
  local clang="$BUILD_DIR/build/bin/clang-$CLANGVER"
  if filc_clean_filter clang; then filc_clean_portion clang; fi
  if [ -x "$clang" ]; then
    if { [ "${1:-}" = static ] && filc_clang_is_universal; } \
        || { [ "${1:-}" != static ] && ! filc_clang_is_universal; }; then
      echo "clang already built: $("$clang" --version | head -1)"
      return
    fi
    # The other linkage: the same cmake run below only re-links clang, as every object
    # is still there.
    echo "clang is built with the other C++ runtime linkage; re-linking it ..."
  elif [ ! -f "$BUILD_DIR/build/CMakeCache.txt" ]; then
    echo "No clang build in $BUILD_DIR/build yet; compiling LLVM+Clang from scratch (hours)."
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
  # shellcheck disable=SC1091
  . "$BUILD_DIR/libpas/common.sh"   # LLVMARCH, NCPU
  # The repository and revision clang --version names, without the access token a remote
  # URL may carry (LLVM refuses to embed one).
  local vcrepo vcrev
  vcrepo="$(git -C "$ROOT/compiler" remote get-url origin 2>/dev/null \
            | sed -E 's#^(https?://)[^@/]*@#\1#' || true)"
  vcrev="$(git -C "$ROOT/compiler" rev-parse HEAD 2>/dev/null || true)"
  # Both ways are spelled out, as cmake keeps a cached value from the previous run.
  local extra="-DLLVM_STATIC_LINK_CXX_STDLIB=OFF -DCMAKE_EXE_LINKER_FLAGS="
  if [ "${1:-}" = static ]; then
    # Portable: fold the C++ runtime into the binary so it runs regardless of the host's
    # libstdc++/libgcc version. (glibc stays dynamic -- it is backward compatible, and a
    # fully-static libc clang is impractical: NSS/dlopen.)
    extra="-DLLVM_STATIC_LINK_CXX_STDLIB=ON -DCMAKE_EXE_LINKER_FLAGS=-static-libgcc"
  fi
  export TMPDIR="$BUILD_DIR/tmp-build"; mkdir -p "$TMPDIR"
  mkdir -p "$BUILD_DIR/build"
  ( cd "$BUILD_DIR/build"
    cmake -S ../llvm -B . -G Ninja \
      -DLLVM_ENABLE_PROJECTS=clang \
      -DLLVM_FORCE_VC_REPOSITORY="$vcrepo" \
      -DLLVM_FORCE_VC_REVISION="$vcrev" \
      -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON \
      -DLLVM_ENABLE_LLD=ON -DLLVM_TARGETS_TO_BUILD="$LLVMARCH" \
      -DCMAKE_C_COMPILER="${HOSTCC:-/usr/bin/clang}" \
      -DCMAKE_CXX_COMPILER="${HOSTCXX:-/usr/bin/clang++}" \
      -DLLVM_PARALLEL_LINK_JOBS=1 \
      -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_BENCHMARKS=OFF \
      -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_LIBPFM=OFF \
      -DLLVM_ENABLE_ZLIB=OFF -DLLVM_ENABLE_ZSTD=OFF -DLLVM_ENABLE_CURL=OFF \
      -DLLVM_ENABLE_HTTPLIB=OFF \
      $extra
    ninja -j "${NCPU:-1}" clang
    # fix_clang.sh: drop the build rpath and add the Fil-C driver aliases.
    patchelf --remove-rpath "bin/clang-$CLANGVER" 2>/dev/null || true
    ( cd bin && for l in filcc fil++ filcpp; do ln -fs "clang-$CLANGVER" "$l"; done ) )
  BUILT="$BUILT clang"
  filc_sync_portion clang
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

filc_build_runtime_libc() {
  [ -x "$BUILD_DIR/build/bin/clang" ] || { echo "ERROR: no clang at $BUILD_DIR/build/bin/clang" >&2; exit 1; }
  export TMPDIR="$BUILD_DIR/tmp-build"; mkdir -p "$TMPDIR"
  export HOST_CLANG
  if [ -f "$TOOLS/bison-share/m4sugar/m4sugar.m4" ]; then
    export BISON_PKGDATADIR="$TOOLS/bison-share"
  fi
  # build_base.sh minus its two clang-building steps: reuse the clang, build only the
  # runtime + libc layers into pizfix/.
  filc_portion crt    bash ./build_compiler_rt.sh
  filc_portion unwind bash ./build_yolounwind.sh
  filc_portion osinc  bash ./build_os_include.sh
  filc_portion yolo   bash ./build_yolo_glibc.sh
  filc_portion pas    filc_build_pas
  filc_portion libc   bash ./build_user_glibc.sh
  echo "Build complete. Runtime + libc are in $BUILD_DIR/pizfix/lib :"
  ls -1 "$BUILD_DIR/pizfix/lib/libpizlo.so" "$BUILD_DIR"/pizfix/lib/libc.so* 2>/dev/null || true
}

# ---------- pack the built toolchain ----------
# Archives the *usable* toolchain (not the LLVM build tree): the clang driver + its resource
# dir + the pizfix sysroot, from <dir> (default: the build folder). Layout matches an
# upstream Fil-C release, so filc_download_toolchain can unpack it straight into the tree.
filc_make_archive() {   # $1 = platform tag, [$2 = dir]
  local tag="$1" src="${2:-$BUILD_DIR}" out stage clang
  clang="$src/build/bin/clang-$CLANGVER"
  out="$DIST/filc-$tag.xz"
  stage="$TOOLS/stage"
  echo "===== packing $out ====="
  rm -rf "$stage"; mkdir -p "$stage/build/bin" "$stage/build/lib" "$DIST"
  cp -a "$clang" "$stage/build/bin/"
  ( cd "$stage/build/bin"
    for l in clang clang++ filcc fil++ filcpp; do ln -fs "clang-$CLANGVER" "$l"; done )
  cp -a "$src/build/lib/clang" "$stage/build/lib/"   # builtin-header resource dir
  cp -a "$src/pizfix" "$stage/pizfix"                # runtime + libc + libc++ sysroot
  strip "$stage/build/bin/clang-$CLANGVER" 2>/dev/null || true
  tar -C "$stage" -cf - build pizfix | xz -9 -T0 -c > "$out"
  rm -rf "$stage"
  echo "archive: $out ($(du -h "$out" | cut -f1))"
  echo "clang needs glibc >= $(filc_clang_glibc_floor "$clang") on the host;" \
       "C++ runtime: $(filc_clang_is_universal "$clang" && echo static || echo dynamic)."
}

# Fails, saying why, unless dist/filc-<tag>.xz was written by this run (newer than
# <marker>), is not empty, and passes `xz -t`; nothing is published from a failed pack.
filc_check_archive() {   # $1 = platform tag, $2 = marker file of the run's start
  local out="$DIST/filc-$1.xz"
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
# Prints the clang that describes the archives: the build folder's, else the tree's.
filc_built_clang() {
  if [ -x "$BUILD_DIR/build/bin/clang-$CLANGVER" ]; then
    echo "$BUILD_DIR/build/bin/clang-$CLANGVER"
  else
    echo "$ROOT/build/bin/clang-$CLANGVER"
  fi
}

# Prints the label of the asset filc-<tag>.xz: which hosts it is for, and the oldest
# glibc its clang needs (see filc_built_clang).
filc_asset_label() {   # $1 = platform tag
  local where floor
  if [ "$1" = "$UNIVERSAL_PLAT" ]; then
    where="Any Linux $ARCH (universal)"
  else
    where="$(printf '%s' "${1%-"$ARCH"}" | sed 's/./\U&/') $ARCH"
  fi
  floor="$(filc_clang_glibc_floor "$(filc_built_clang)")"
  printf '%s%s\n' "$where" "${floor:+ - needs glibc >= $floor}"
}

# Regenerates the release's name and text from all of its assets (their names and
# labels), and updates the release when they differ, so the page always says what the
# scripts know.
FILC_PAGE_PY='
import json, sys
rel = json.load(sys.stdin)
ver, arch, clangver = sys.argv[1:]
def describe(asset):
    if asset.get("label") and asset["label"] != asset["name"]:
        return asset["label"]
    tag = asset["name"][len("filc-"):-len(".xz")]
    words = tag.replace("-", " ")
    return words[:1].upper() + words[1:]
assets = sorted((a for a in rel.get("assets", []) if a["name"].endswith(".xz")),
                key=lambda a: ("universal" in a["name"], a["name"]))
body = "\n\n".join([
    "Prebuilt Fil-C %s toolchain: the Fil-C clang (`build/`: clang-%s + driver aliases)"
    " and its runtime (`pizfix/`: libpizlo, libc.so.6666, libc++)." % (ver, clangver),
    "Assets:\n" + "\n".join("- `%s`: %s" % (a["name"], describe(a)) for a in assets),
    "`filc-light`'"'"'s `build.sh` fetches this via `.../releases/latest/download` when"
    " run without `--nightly`, trying its distribution'"'"'s asset first, then the"
    " universal one.",
])
name = "Fil-C %s prebuilt toolchain (%s)" % (ver, arch)
if rel.get("body") == body and rel.get("name") == name:
    sys.exit(0)
print(json.dumps({"name": name, "body": body}))
'

# Prepares a GitHub API session for the compiler/ submodule's repo: sets SLUG, VER (the
# Fil-C version of the built clang), API, and HDR (a private header file holding the
# token, never put on a command line). Returns 1, saying why, when publishing is not
# possible; filc_github_end removes the header file.
filc_github_begin() {
  local token clang
  SLUG="$(filc_compiler_repo_slug)"
  if [ -z "$SLUG" ]; then echo "publish: compiler/ is not on GitHub; skipping."; return 1; fi
  token="${FILC_LIGHT_GITHUB_TOKEN:-$(filc_github_token "$SLUG")}"
  if [ -z "$token" ]; then
    echo "publish: no git remote of $SLUG carries an access token; skipping."
    return 1
  fi
  clang="$(filc_built_clang)"
  VER="$("$clang" --version 2>/dev/null | sed -n 's/.*(Fil-C \([0-9][0-9.]*\).*/\1/p' | head -1)"
  if [ -z "$VER" ]; then echo "publish: cannot read the Fil-C version of $clang" >&2; return 1; fi
  API="https://api.github.com/repos/$SLUG"
  HDR="$(mktemp)"
  chmod 600 "$HDR"
  printf 'Authorization: token %s\nAccept: application/vnd.github+json\n' "$token" > "$HDR"
}

filc_github_end() {
  rm -f "$HDR"
}

# Regenerates the name and text of the release v<VER> from all of its assets; needs a
# session from filc_github_begin.
filc_publish_page() {
  local rel id patch
  rel="$(curl -sS -H @"$HDR" "$API/releases/tags/v$VER")"
  id="$(printf '%s' "$rel" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("id", ""))')"
  if [ -z "$id" ]; then echo "publish: no release v$VER on $SLUG yet" >&2; return 1; fi
  patch="$(printf '%s' "$rel" | python3 -c "$FILC_PAGE_PY" "$VER" "$ARCH" "$CLANGVER")"
  if [ -z "$patch" ]; then
    echo "publish: the text of https://github.com/$SLUG/releases/tag/v$VER is up to date."
    return 0
  fi
  printf '%s' "$patch" | curl -sS -f -H @"$HDR" -X PATCH --data-binary @- -o /dev/null "$API/releases/$id" \
    || { echo "publish: cannot update the release text of v$VER" >&2; return 1; }
  echo "publish: regenerated the name and text of https://github.com/$SLUG/releases/tag/v$VER"
}

# Publishes dist/filc-<tag>.xz on the release v<Fil-C version> of the compiler/
# submodule's GitHub repo, where filc_download_toolchain fetches it from: creates that
# release (marked latest) when missing, keeps an identical asset (updating only its
# label), replaces an older one of the same name, then regenerates the release's name
# and text. Without a token (see filc_github_token) it skips publishing and says so.
filc_upload_archive() {   # $1 = platform tag
  local name="filc-$1.xz" file rel id asset label sum q
  file="$DIST/$name"
  [ -f "$file" ] || { echo "publish: no $file" >&2; return 1; }
  filc_github_begin || return 0
  label="$(filc_asset_label "$1")"
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
    python3 -c 'import json,sys; print(json.dumps({"label": sys.argv[1]}))' "$label" \
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
    q="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.urlencode({"name": sys.argv[1], "label": sys.argv[2]}))' "$name" "$label")"
    curl -sS -f -H @"$HDR" -H "Content-Type: application/x-xz" --data-binary @"$file" \
         -o /dev/null "https://uploads.github.com/repos/$SLUG/releases/$id/assets?$q" \
      || { filc_github_end; echo "publish: upload of $name failed" >&2; return 1; }
    echo "publish: published https://github.com/$SLUG/releases/download/v$VER/$name"
  fi
  filc_publish_page || { filc_github_end; return 1; }
  filc_github_end
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
  echo "usage: $0 [--nightly|--latest] [--universal|--static|--general] [--sync[=<re>]]" \
       "[--no-sync] [--clean[=<re>]] [--rebuild[=<re>]] [-d <dir>|--directory=<dir>]" \
       "[--no-xz|--no-archive]" \
       "[--no-publish|--no-upload] [--publish|--upload] [--no-build|--no-rebuild]" \
       "[--export] [--install]" >&2
  exit 2
}

# Sets MODE, STATIC, NOXZ, PUBLISH, SYNC, FILC_SYNC_FILTER, FILC_CLEAN_FILTER and
# BUILD_DIR from the arguments, in order: a later flag overrides an earlier one. MODE is
# download, source, clean (clean only), export, upload (publish dist/ without building)
# or install.
filc_parse_args() {
  MODE=download      # default: fetch a prebuilt toolchain
  STATIC=""
  NOXZ=""
  PUBLISH=1          # a from-source build publishes its archive
  SYNC=1             # the tree's toolchain is updated once the build is done
  FILC_SYNC_FILTER=""
  FILC_CLEAN_FILTER=""
  local asked_publish="" nobuild=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --nightly|--latest)   MODE=source; nobuild="" ;;
      --universal|--static|--general) MODE=source; STATIC=static; nobuild="" ;;
      --no-build|--no-rebuild) nobuild=1 ;;
      --sync)               SYNC=1; FILC_SYNC_FILTER='^.*$' ;;
      --sync=*)             SYNC=1; FILC_SYNC_FILTER="${1#--sync=}"; [ -n "$FILC_SYNC_FILTER" ] || FILC_SYNC_FILTER='^.*$' ;;
      --no-sync)            SYNC=0; FILC_SYNC_FILTER="" ;;
      --clean)              FILC_CLEAN_FILTER='^.*$' ;;
      --clean=*)            FILC_CLEAN_FILTER="${1#--clean=}"
                            [ -n "$FILC_CLEAN_FILTER" ] || FILC_CLEAN_FILTER='^.*$' ;;
      # --rebuild is --clean plus a from-source build.
      --rebuild)            MODE=source; nobuild=""; FILC_CLEAN_FILTER='^.*$' ;;
      --rebuild=*)          MODE=source; nobuild=""; FILC_CLEAN_FILTER="${1#--rebuild=}"
                            [ -n "$FILC_CLEAN_FILTER" ] || FILC_CLEAN_FILTER='^.*$' ;;
      -d|--directory)
        # A relative value is absolutised: the build cds around before reusing BUILD_DIR.
        [ $# -ge 2 ] || filc_usage
        case "$2" in /*) BUILD_DIR="$2" ;; *) BUILD_DIR="$(pwd)/$2" ;; esac
        shift ;;
      --directory=*)
        case "${1#--directory=}" in /*) BUILD_DIR="${1#--directory=}" ;; *) BUILD_DIR="$(pwd)/${1#--directory=}" ;; esac ;;
      --no-xz|--no-archive) NOXZ=1 ;;
      --no-publish|--no-upload) PUBLISH=0; asked_publish="" ;;
      --export)             MODE=export ;;
      --publish|--upload)   PUBLISH=1; asked_publish=1 ;;
      --install)            MODE=install ;;
      ""|--build)           MODE=source; nobuild="" ;;   # explicit build == from source
      -h|--help)            sed -n '2,/^set -euo pipefail$/{/^set -euo/!p}' "${BASH_SOURCE[0]}"; exit 0 ;;
      *) filc_usage ;;
    esac
    shift
  done
  # Publishing what dist/ already holds needs --no-build; --publish otherwise builds
  # first, so only a fresh archive is published. An export publishes only when asked.
  # --clean with nothing to build only cleans.
  if [ -n "$nobuild" ] && [ "$MODE" != export ]; then
    if [ -n "$FILC_CLEAN_FILTER" ] && [ -z "$asked_publish" ]; then
      MODE=clean
    elif [ -z "$asked_publish" ]; then
      echo "--no-build: nothing to do; combine it with --publish or --clean (or use --export)." >&2
      exit 2
    else
      MODE=upload
    fi
  elif [ -n "$FILC_CLEAN_FILTER" ] && [ "$MODE" = download ] && [ -z "$asked_publish" ]; then
    MODE=clean
  elif [ -n "$asked_publish" ] && [ "$MODE" = download ]; then
    MODE=source
  fi
  if [ "$MODE" = export ] && [ -z "$asked_publish" ]; then PUBLISH=0; fi
  # The build folder sits beside the tree, the way XD's build-handler places its own.
  : "${BUILD_DIR:=$(dirname "$ROOT")/build/$(basename "$ROOT")${FILC_BUILD_DIR_SUFFIX:-}}"
}

filc_main() {
  BUILT=""
  SYNCED=""
  filc_parse_args "$@"
  filc_detect_platform
  # The run's start, against which a fresh archive is told from an old one; the second
  # of waiting keeps an archive packed right away newer than it on any file system.
  local started=""
  case "$MODE" in
    source|export)
      mkdir -p "$TOOLS"
      started="$(mktemp "$TOOLS/.run-start.XXXXXX")"
      trap 'rm -f "$started"' EXIT
      sleep 1 ;;
  esac
  case "$MODE" in
    install)
      filc_install_bison
      ;;
    clean)
      filc_clean_all
      ;;
    export)
      local clang="$ROOT/build/bin/clang-$CLANGVER" tag
      [ -x "$clang" ] || { echo "export: no toolchain in $ROOT/build to pack" >&2; exit 1; }
      tag="$(filc_clang_is_universal "$clang" && echo "$UNIVERSAL_PLAT" || echo "$PLAT")"
      filc_make_archive "$tag" "$ROOT"
      filc_check_archive "$tag" "$started" || exit 1
      [ "$PUBLISH" != 1 ] || filc_upload_archive "$tag"
      ;;
    upload)
      local found="" tag
      for tag in "$PLAT" "$UNIVERSAL_PLAT"; do
        if [ -f "$DIST/filc-$tag.xz" ]; then found=1; filc_upload_archive "$tag"; fi
      done
      if [ -z "$found" ]; then
        # No archive to add: the release page alone is regenerated.
        echo "publish: no filc-*.xz archive in $DIST; regenerating the release page only."
        if filc_github_begin; then
          filc_publish_page || { filc_github_end; exit 1; }
          filc_github_end
        fi
      fi
      ;;
    download|source)
      if [ "$MODE" = download ]; then
        if filc_download_toolchain; then exit 0; fi
        echo ">>> no prebuilt archive; building from source (use --nightly to force this)."
      fi
      filc_install_bison
      filc_mirror
      filc_build_clang "$STATIC"
      if [ -n "$STATIC" ] && [ -f "$BUILD_DIR/pizfix/lib/libpizlo.so" ] \
          && ! filc_clean_wants_runtime; then
        # The runtime does not depend on how clang links its C++ runtime.
        echo "pizfix/ runtime already built; reusing it for the universal archive."
      else
        filc_build_runtime_libc
      fi
      # The entire build is done: only now does the tree's toolchain change.
      if [ "$SYNC" = 1 ]; then
        filc_sync_all
      else
        echo "(--no-sync: the tree's toolchain is left as it was; the build is in $BUILD_DIR)"
      fi
      if [ -z "$NOXZ" ]; then
        local tag
        tag="$([ -n "$STATIC" ] && echo "$UNIVERSAL_PLAT" || echo "$PLAT")"
        filc_make_archive "$tag"
        filc_check_archive "$tag" "$started" || exit 1
        [ "$PUBLISH" != 1 ] || filc_upload_archive "$tag"
      else
        echo "(--no-xz: skipping archive generation)"
      fi
      ;;
  esac
}

# Runs only when executed; tests/build.spec.sh sources this file for its functions.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  filc_main "$@"
fi
