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
- The `build_*.sh` / `configure_*.sh` scripts for the steps above.

Both libc families are supported, glibc and musl, the same as full Fil-C.

## What is NOT included (and why)

The Fil-C Clang compiler sources (`llvm/`, `clang/`), the C++ standard library build,
and every ported application (`projects/*` other than the libc slices) are left out
to keep this tree small. Build those from the full Fil-C tree if you need them.

## The compiler: bring your own native Clang

Fil-C-Light does NOT build the compiler. Its steps reuse an EXISTING native Clang as
the host compiler that produces the native runtime objects. Pick one, cheapest first:

1. A system `clang` already on `PATH` (nothing to install).
2. `apt install clang` (the distro LLVM build, a few hundred MB).
3. The Android NDK's bundled `clang` (a larger download; use only when apt is not
   available).

The Fil-C instrumenting Clang itself (`build/bin/clang`) comes from a full Fil-C build
or a Fil-C release; place its `build/` next to this tree's `pizfix/` so the libc and
runtime steps can compile and link.

## Building

Reuse an existing native clang as `HOST_CLANG`, then run the runtime and libc steps
(this is `build_base.sh` without its two Clang steps): `build_compiler_rt.sh`,
`build_yolounwind.sh`, `build_os_include.sh`, the yolo libc (`build_yolomusl.sh` or
`build_yolo_glibc.sh`), `build_runtime.sh`, and the user libc (`build_usermusl.sh` or
`build_user_glibc.sh`). For the glibc path, `build_all_glibc.sh` runs these in order.
