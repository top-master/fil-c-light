# Fil-C-Light

A light, source-only subset of Fil-C. It carries just what is needed to build the
Fil-C memory-safe RUNTIME and its two C library slices, so a small or disk-limited
machine can rebuild them without the full multi-gigabyte Fil-C tree.

## What is included

- `libpas/` and `filc/`: the Fil-C runtime (libpizlo) plus its headers, tests, and
  startup code.
- `compiler-rt/`, `libunwind/`, and `yolounwind/`: the low-level support the runtime
  links against.
- `projects/yolomusl` and `projects/usermusl`: the musl libc slices.
- `projects/yolo-glibc-*` and `projects/user-glibc-*`: the glibc libc slices (2.44,
  which builds against Linux 7.0 kernel headers; 2.40 does not).
- The `build_*.sh` / `configure_*.sh` scripts for the steps above, and `build.sh`,
  the driver that runs them (see "Building").
- `compiler/`: a removable submodule with the LLVM + Clang sources of the Fil-C
  compiler, needed only to build that compiler from source.

Both libc families are supported, glibc and musl, the same as full Fil-C.

## What is NOT included (and why)

The C++ standard library build and every ported application (`projects/*` other than
the libc slices) are left out to keep this tree small. Build those from the full
Fil-C tree if you need them. The compiler sources are not in this tree itself: they
live in the `compiler/` submodule, which is fetched only when the compiler is built.

## The compiler: prebuilt, or built from `compiler/`

`./build.sh` fetches a prebuilt Fil-C toolchain (the instrumenting Clang in `build/`
plus the runtime in `pizfix/`) from the `compiler/` repository's releases, so most
machines never compile LLVM. Building it from source is optional (see "Building").
Either way, an EXISTING native Clang is needed as the host compiler, for the runtime
objects and for an LLVM build. Pick one, cheapest first:

1. A system `clang` already on `PATH` (nothing to install).
2. `apt install clang` (the distro LLVM build, a few hundred MB).
3. The Android NDK's bundled `clang` (a larger download; use only when apt is not
   available).

The Fil-C instrumenting Clang itself (`build/bin/clang`) can also come from a full
Fil-C build or a Fil-C release; place its `build/` next to this tree's `pizfix/` so
the libc and runtime steps can compile and link.

## Building

`build.sh` is the entry point; `./build.sh --help` lists every option.

    ./build.sh                 # fetch the prebuilt toolchain for this platform
    ./build.sh --nightly       # build the compiler, runtime and glibc slice from source
    ./build.sh --universal     # the same, with a clang that runs on any Linux
    ./build.sh --clean=pas     # remove one portion's build output, build nothing
    ./build.sh --rebuild=pas   # rebuild one portion from scratch
    ./build.sh --export        # pack the toolchain in use into dist/, nothing else

A from-source build runs in a build folder beside this tree (`../build/filc-light`),
and updates this tree's `build/` and `pizfix/` only once the whole build succeeds.
Its archive (`dist/filc-<platform>.xz`) is then published on the `compiler/`
repository's releases when a `git remote` of it carries an access token
(`--no-publish` keeps it local). Run `bash tests/build.spec.sh` to test `build.sh`.

Underneath, `build.sh` runs the upstream steps, which also work by hand. Reuse an
existing native clang as `HOST_CLANG`, then run the runtime and libc steps (this is
`build_base.sh` without its two Clang steps): `build_compiler_rt.sh`,
`build_yolounwind.sh`, `build_os_include.sh`, the yolo libc (`build_yolomusl.sh` or
`build_yolo_glibc.sh`), `build_runtime.sh`, and the user libc (`build_usermusl.sh` or
`build_user_glibc.sh`). For the glibc path, `build_all_glibc.sh` runs these in order.
