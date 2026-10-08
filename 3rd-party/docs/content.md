
As mentioned in the root [README.md](../../README.md) file, we don't ship noise,
just pure Fil-C functionality -- see details below.

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

Both libc families are supported, glibc and musl, the same as full Fil-C. Upstream's
third flavor, cosmopolitan libc, is not in this tree: it is the optional
`3rd-party/libc-cosmo` submodule (the `fil-c-cosmo` repo), fetched only by `./build.sh
--cosmo`.


## What is NOT included (and why)

Every ported application (`projects/*` other than the libc slices) is left out to
keep this tree small; build those from the full Fil-C tree if you need them. The C++
standard library (libc++ and libc++abi) is built from the `compiler/` submodule's
runtime sources and ships with the toolchain. The compiler sources are not in this
tree itself: they live in the `compiler/` submodule, which is fetched only when the
compiler is built.


## The compiler: prebuilt, or built from `compiler/`

`./build.sh` fetches a prebuilt Fil-C toolchain, the published optfil package of
this tree's upstream version, from the `compiler/` repository's releases and lays it
out as the instrumenting Clang in `build/` plus the runtime in `pizfix/`;
`./build.sh --no-build` installs it at `/opt/fil` instead (with `--no-install`, it
only unpacks it into the tree). So most machines never compile LLVM. Building it
from source is optional (see "Building"). Either way, an EXISTING native Clang is
needed as the host compiler, for the runtime objects and for an LLVM build. Pick
one, cheapest first:

1. A system `clang` already on `PATH` (nothing to install).
2. `apt install clang` (the distro LLVM build, a few hundred MB).
3. The Android NDK's bundled `clang` (a larger download; use only when apt is not
   available).

The Fil-C instrumenting Clang itself (`build/bin/clang`) can also come from a full
Fil-C build or a Fil-C release; place its `build/` next to this tree's `pizfix/` so
the libc and runtime steps can compile and link.
