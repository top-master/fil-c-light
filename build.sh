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
#   ./build.sh --general       As --nightly, but link the clang portably (static libstdc++/
#   ./build.sh --static        libgcc) so it does not depend on the host's C++ runtime
#                              version; archived as dist/filc-linux-general-<arch>.xz.
#
#   ./build.sh --no-xz         With a from-source build, skip generating the .xz archive.
#   ./build.sh --no-archive    (alias of --no-xz)
#
#   ./build.sh --install       Fetch build-only prerequisites that cannot be built from this
#                              tree: the GNU Bison data files (skeletons + m4sugar), in case
#                              the host bison lacks them. Needed before a from-source build.
#
#   ./build.sh -h | --help
#
# Env overrides:
#   FILC_LIGHT_RELEASE_URL   Base URL that hosts the prebuilt filc-<platform>.xz archives.
#                            If unset, it is derived from the 'origin' GitHub remote
#                            (…/releases/latest/download). If neither is available, the
#                            default falls through to a from-source build.
#   HOST_CLANG               Native clang used to compile the runtime (default: clang).
#   HOSTCC / HOSTCXX         Native C/C++ compiler used to build clang itself
#                            (default: /usr/bin/clang, /usr/bin/clang++ -- lighter on RAM
#                            than gcc for an LLVM build).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TOOLS="$ROOT/.filc-light-tools"
DIST="$ROOT/dist"
HOST_CLANG="${HOST_CLANG:-clang}"
CLANGVER=20                       # LLVM major of the Fil-C fork (produces bin/clang-20)

# ---------- platform identity ----------
# PLAT         distro-specific, dynamically linked   -> filc-ubuntu-x86_64.xz
# GENERAL_PLAT portable, static libstdc++/libgcc      -> filc-linux-general-x86_64.xz
detect_platform() {
  ARCH="$(uname -m)"
  local id=linux
  if [ -r /etc/os-release ]; then . /etc/os-release; id="${ID:-linux}"; fi
  PLAT="${id}-${ARCH}"
  GENERAL_PLAT="linux-general-${ARCH}"
}

# Base URL for prebuilt archives: explicit env wins, else derive from the compiler repo.
# The prebuilt toolchain (clang + pizfix) is published on the compiler/ submodule's repo's
# releases, not on this light repo -- so derive the base from that submodule URL (.gitmodules
# is the single source of truth for it; never hardcode/duplicate the URL here).
release_base_url() {
  if [ -n "${FILC_LIGHT_RELEASE_URL:-}" ]; then echo "$FILC_LIGHT_RELEASE_URL"; return; fi
  local url path
  url="$(git -C "$ROOT" config -f "$ROOT/.gitmodules" submodule.compiler.url 2>/dev/null || true)"
  case "$url" in
    ../*)                 # relative submodule URL: resolve against origin's parent
      local o; o="$(git -C "$ROOT" remote get-url origin 2>/dev/null || true)"; o="${o%.git}"
      url="${o%/*}/${url#../}" ;;
  esac
  case "$url" in
    https://github.com/*) echo "${url%.git}/releases/latest/download" ;;
    git@github.com:*)     path="${url#git@github.com:}"; path="${path%.git}"
                          echo "https://github.com/$path/releases/latest/download" ;;
    *) echo "" ;;
  esac
}

# ---------- prebuilt fast path ----------
download_toolchain() {
  detect_platform
  local base; base="$(release_base_url)"
  if [ -z "$base" ]; then
    echo "No prebuilt-release URL (set FILC_LIGHT_RELEASE_URL or add a GitHub 'origin')."
    return 1
  fi
  mkdir -p "$TOOLS"
  local tag f
  for tag in "$PLAT" "$GENERAL_PLAT"; do          # prefer the exact distro build, then general
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
  echo "No prebuilt archive available for $PLAT or $GENERAL_PLAT."
  return 1
}

# ---------- from-source: the compiler ----------
build_clang() {   # $1 = "static" for the portable general build
  if [ -x "$ROOT/build/bin/clang-$CLANGVER" ]; then
    echo "clang already built: $("$ROOT/build/bin/clang-$CLANGVER" --version | head -1)"
    return
  fi
  # The llvm+clang+cmake sources live in the compiler/ submodule; init it if needed.
  if [ ! -e "$ROOT/compiler/llvm/CMakeLists.txt" ]; then
    echo "Initialising the compiler/ submodule (llvm+clang+cmake) ..."
    git -C "$ROOT" -c protocol.file.allow=always submodule update --init compiler
  fi
  # LLVM's build wants llvm/, clang/ and the repo-root cmake/ as siblings at the tree root.
  local d
  for d in llvm clang cmake; do [ -e "$ROOT/$d" ] || ln -s "compiler/$d" "$ROOT/$d"; done
  # shellcheck disable=SC1091
  . "$ROOT/libpas/common.sh"        # LLVMARCH, NCPU
  local extra=""
  if [ "${1:-}" = static ]; then
    # Portable: fold the C++ runtime into the binary so it runs regardless of the host's
    # libstdc++/libgcc version. (glibc stays dynamic -- it is backward compatible, and a
    # fully-static libc clang is impractical: NSS/dlopen.)
    extra="-DLLVM_STATIC_LINK_CXX_STDLIB=ON -DCMAKE_EXE_LINKER_FLAGS=-static-libgcc"
  fi
  export TMPDIR="$ROOT/tmp-build"; mkdir -p "$TMPDIR"
  mkdir -p "$ROOT/build"
  ( cd "$ROOT/build"
    cmake -S ../llvm -B . -G Ninja \
      -DLLVM_ENABLE_PROJECTS=clang \
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
}

# ---------- from-source: runtime + libc ----------
build_runtime_libc() {
  [ -x "$ROOT/build/bin/clang" ] || { echo "ERROR: no clang at build/bin/clang" >&2; exit 1; }
  export TMPDIR="$ROOT/tmp-build"; mkdir -p "$TMPDIR"
  export HOST_CLANG
  if [ -f "$TOOLS/bison-share/m4sugar/m4sugar.m4" ]; then
    export BISON_PKGDATADIR="$TOOLS/bison-share"
  fi
  cd "$ROOT"
  # build_base.sh minus its two clang-building steps: reuse the clang, build only the
  # runtime + libc layers into pizfix/.
  local s
  for s in build_compiler_rt.sh build_yolounwind.sh build_os_include.sh build_yolo_glibc.sh; do
    echo "===== $s ====="
    bash "./$s"
  done
  # libpas: on a single core, make -j hits a gen-order race where filc_native_forwarders.c
  # compiles before the generated filc_native.h exists. Run the script; if it trips that
  # race, generate the header and resume make (do NOT re-run the script -- its clean.sh
  # would delete the header again).
  echo "===== build_runtime.sh ====="
  if ! bash ./build_runtime.sh; then
    echo "runtime: filc_native.h gen-order race -> generating header and resuming make"
    ( cd libpas
      ruby src/libpas/generate_pizlonated_forwarders.rb src/libpas/filc_native.h
      . ./common.sh
      "$MAKE" -f Makefile -j "${NCPU:-1}" )
  fi
  echo "===== build_user_glibc.sh ====="
  bash ./build_user_glibc.sh
  echo "Build complete. Runtime + libc are in $ROOT/pizfix/lib :"
  ls -1 "$ROOT/pizfix/lib/libpizlo.so" "$ROOT"/pizfix/lib/libc.so* 2>/dev/null || true
}

# ---------- pack the built toolchain ----------
# Archives the *usable* toolchain (not the LLVM build tree): the clang driver + its resource
# dir + the pizfix sysroot. Layout matches an upstream Fil-C release, so download_toolchain
# can unpack it straight into the tree.
make_archive() {   # $1 = platform tag
  local tag="$1" out stage
  out="$DIST/filc-$tag.xz"
  stage="$TOOLS/stage"
  echo "===== packing $out ====="
  rm -rf "$stage"; mkdir -p "$stage/build/bin" "$stage/build/lib" "$DIST"
  cp -a "$ROOT/build/bin/clang-$CLANGVER" "$stage/build/bin/"
  ( cd "$stage/build/bin"
    for l in clang clang++ filcc fil++ filcpp; do ln -fs "clang-$CLANGVER" "$l"; done )
  cp -a "$ROOT/build/lib/clang" "$stage/build/lib/"      # builtin-header resource dir
  cp -a "$ROOT/pizfix" "$stage/pizfix"                   # runtime + libc + libc++ sysroot
  strip "$stage/build/bin/clang-$CLANGVER" 2>/dev/null || true
  tar -C "$stage" -cf - build pizfix | xz -9 -T0 -c > "$out"
  rm -rf "$stage"
  echo "archive: $out ($(du -h "$out" | cut -f1))"
}

# ---------- prerequisites ----------
install_bison() {
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
MODE=download      # default: fetch a prebuilt toolchain
STATIC=""
NOXZ=""
for arg in "$@"; do
  case "$arg" in
    --nightly|--latest)   MODE=source ;;
    --general|--static)   MODE=source; STATIC=static ;;
    --no-xz|--no-archive) NOXZ=1 ;;
    --install)            MODE=install ;;
    ""|--build)           MODE=source ;;   # explicit build == from source
    -h|--help)            sed -n '2,44p' "$0"; exit 0 ;;
    *) echo "usage: $0 [--nightly|--latest] [--general|--static] [--no-xz|--no-archive] [--install]" >&2; exit 2 ;;
  esac
done

detect_platform

case "$MODE" in
  install)
    install_bison
    ;;
  download|source)
    if [ "$MODE" = download ]; then
      if download_toolchain; then exit 0; fi
      echo ">>> no prebuilt archive; building from source (use --nightly to force this)."
    fi
    install_bison
    build_clang "$STATIC"
    build_runtime_libc
    if [ -z "$NOXZ" ]; then
      make_archive "$([ -n "$STATIC" ] && echo "$GENERAL_PLAT" || echo "$PLAT")"
    else
      echo "(--no-xz: skipping archive generation)"
    fi
    ;;
esac
