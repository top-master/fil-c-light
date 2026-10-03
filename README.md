# Fil-C-Light

A light, source-only subset of Fil-C. It carries just what is needed to build the
Fil-C memory-safe RUNTIME and its two C library slices, so a small or disk-limited
machine can rebuild them without the full multi-gigabyte Fil-C tree.

See [what's included](3rd-party/docs/content.md)

## Usage

1\. First, run:
```
git clone https://github.com/top-master/fil-c-light.git
```
Since we intentionally drop this repo's git-sub-modules.

2\. Then simply run `./build.sh` without any options to enjoy Fil-C-Light's performance,
which only builds the most change-needing parts of Fil-C and for everything else
uses a prebuilt toolchain based on platform's CPU architecture
(see [fil-c-llvm](https://github.com/top-master/fil-c-llvm/releases) releases: the one of this
tree's upstream version, named by its `upstream-<version>` tag, else the latest one).

---

However, you could also run `./build.sh --help` to lists other options:

    # Main build modes:
    
    ./build.sh --nightly       # Builds everything 100% (nothing stays prebuilt).

    ./build.sh                 # Builds this repo (and tries to fetch the prebuilt toolchain,
                               # if nothing was found for fetching, is same as passing --nightly mode).

    ./build.sh --no-build      # Fetches everything from the prebuilt toolchain
                               # (simulates build's result, while building 0%).

     # Options meant to be combined with said build modes:

    ./build.sh --universal     # Static links to clib of choice, to ensure the toolchain runs on any Linux.

    ./build.sh --archs=all     # Also cross-compile for the other arch (x86_64, aarch64).

    ./build.sh --musl          # The musl slice instead of glibc (in its own build folder).



    ./build.sh --clean=pas     # Remove one portion's build output, build nothing
    ./build.sh --rebuild=pas   # Rebuild one portion from scratch
    ./build.sh --export        # Pack the toolchain in use into dist/, nothing else

For example, my command usually looks like:

    ./build.sh --universal --archs=all

Or like:

    ./build.sh --nightly --universal --archs=x86_64,arm

A from-source build runs in a build folder beside this tree (`../build/fil-c-light`),
and updates this tree's `build/` and `pizfix/` only once the whole build succeeds.
Its package (`dist/optfil-<version>-linux-<arch>.xz` for glibc, `filc-<version>-linux-<arch>.xz`
for musl, see their [naming](https://github.com/top-master/fil-c-llvm#release-naming)) is then
published on the `compiler/`
repository's releases with `--publish`, when a `git remote` of it carries an access
token (by default it stays local). By default it builds for this machine's CPU arch
only; `--archs` adds another one Fil-C supports, cross-compiled in its own build
folder (`../build/fil-c-light-<arch>`) and never put into this tree.
