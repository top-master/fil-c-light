#!/usr/bin/env bash

# License: Apache 2.0 without attribution need.

# Self-test for `build.sh`. Sources the script (its driver runs only when it is
# executed) and exercises every function whose behaviour does not need a real
# LLVM or Fil-C build: argument parsing, the compiler repo and token lookup, the
# build-folder mirror, syncing built portions into the tree, the clang linkage
# checks, the archs of --archs and cross-compiling a foreign one (its cross root,
# compilers and binutils faked), and publishing on a fake GitHub (a `curl`
# stand-in, no network).
#
# Run: `bash tests/build.spec.sh`
# Exit: number of failed specs (0 = all pass).


# ---- source target under test + the shared QtTestLib-styled helpers --
#
# All assertion plumbing (test_begin / test_section / expect /
# expect_int_gt / expect_returns / test_end) lives in
# `3rd-party/automation/test-helpers.sh`, a verbatim copy of XD's.

_spec_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
_root=$(cd "$_spec_dir/.." && pwd)
. "$_root/build.sh"
# build.sh turns these on for itself; a spec keeps running past a failing line.
set +eu
. "$_root/3rd-party/automation/test-helpers.sh"

_sb=$(mktemp -d)

# The versions build.sh reads from the tree's tags (filc_light_version and
# filc_upstream_version), pinned for every test; the tag tests restore the real ones for
# themselves.
_versions=$(declare -f filc_light_version filc_upstream_version)
filc_light_version() { echo 1.0.0; }
filc_upstream_version() { echo 0.685; }
_real_root=$ROOT

test_begin 'build.spec'


# ---- specs: filc_parse_args ---------------------------------------------

test_section 'filc_parse_args -- modes and flags'

_parse() { unset BUILD_DIR; filc_parse_args "$@"; }

_parse
expect 'default mode builds this tree with the prebuilt clang' light "$MODE"
expect 'default build folder is ../build/<tree name>' \
    "$(dirname "$ROOT")/build/$(basename "$ROOT")" "$BUILD_DIR"
_parse --nightly
expect '--nightly builds from source' source "$MODE"
for _f in --universal --static --general; do
    _parse "$_f"
    expect "$_f asks for the universal toolchain, in the default mode" 'light static' "$MODE $STATIC"
done
for _f in --no-universal --no-static --non-universal --non-static; do
    _parse --universal "$_f"
    expect "$_f after --universal asks for the distribution's toolchain again" 'light ' "$MODE $STATIC"
    _parse "$_f" --static
    expect "--static after $_f asks for the universal one again" 'light static' "$MODE $STATIC"
done
_parse --publish
expect '--publish alone builds this tree, then publishes' 'light 1' "$MODE $PUBLISH"
_parse --upload
expect '--upload is the same as --publish' 'light 1' "$MODE $PUBLISH"
_parse --no-xz
expect '--no-xz sets its flag' 1 "$NOXZ"
_parse --no-archive
expect '--no-archive is the same as --no-xz' 1 "$NOXZ"
_parse --nightly
expect 'a build syncs by default, and publishes only when asked' '0 1' "$PUBLISH $SYNC"
_parse --export
expect '--export only exports, without publishing' 'export 0' "$MODE $PUBLISH"

test_section 'filc_main -- the run marker exists only where an archive is packed'

_marker_count() {   # $@ = flags; a fake clang stands in for the toolchain
    (
        ROOT=$_sb/marker-tree; BUILD_DIR=$_sb/marker-ws; TOOLS=$_sb/marker-tools; DIST=$ROOT/dist
        rm -rf "$ROOT" "$TOOLS" "$BUILD_DIR"
        mkdir -p "$ROOT/build/bin" "$ROOT/build/lib/clang" "$ROOT/pizfix" "$BUILD_DIR"
        printf '#!/bin/sh\n' > "$ROOT/build/bin/clang-20"; chmod +x "$ROOT/build/bin/clang-20"
        filc_clean_all() { ls "$TOOLS"/.run-start.* 2>/dev/null | wc -l | tr -d " "; }
        filc_upstream_package() { ls "$TOOLS"/.run-start.* 2>/dev/null | wc -l | tr -d " "; exit 0; }
        filc_main "$@" 2>/dev/null
    )
}
expect 'a clean-only run makes no marker (and does not wait)' 0 "$(_marker_count --clean)"
expect 'an export makes one' 1 "$(_marker_count --export)"
expect 'which is removed at exit, without an error' '0 ' \
    "$(_marker_count --export 2>&1 > /dev/null; ls "$_sb"/marker-tools/.run-start.* 2>/dev/null | wc -l | tr -d ' ') $( (
        ROOT=$_sb/marker-tree; BUILD_DIR=$_sb/marker-ws; TOOLS=$_sb/marker-tools; DIST=$ROOT/dist
        filc_upstream_package() { exit 0; }
        filc_main --export ) 2>&1 | grep -o 'unbound variable')"

test_section 'filc_parse_args -- a later flag overrides an earlier one'

_parse --nightly --no-upload
expect '--no-upload turns publishing off' 'source 0' "$MODE $PUBLISH"
_parse --nightly --no-publish
expect '--no-publish is the same as --no-upload' 'source 0' "$MODE $PUBLISH"
_parse --nightly --no-upload --publish
expect '--publish after --no-upload turns it back on, still building' 'source 1' "$MODE $PUBLISH"
_parse --nightly --publish --no-publish
expect '--no-publish after --publish turns it off' 'source 0' "$MODE $PUBLISH"
_parse --publish --nightly
expect 'a build flag after --publish still builds, and publishes' 'source 1' "$MODE $PUBLISH"
_parse --publish --no-publish
expect '--no-publish cancels a bare --publish' 'light 0' "$MODE $PUBLISH"

test_section 'filc_parse_args -- --no-build publishes what dist/ holds'

_parse --no-build --publish
expect '--no-build --publish publishes dist/ without building' upload "$MODE"
_parse --publish --no-rebuild
expect '--no-rebuild is the same, in either order' upload "$MODE"
_parse --nightly --no-build --publish
expect '--no-build after a build flag cancels the build' upload "$MODE"
_parse --no-build --nightly --publish
expect 'a build flag after --no-build builds again' 'source 1' "$MODE $PUBLISH"
_parse --export --no-build
expect '--export ignores --no-build (it never builds)' 'export 0' "$MODE $PUBLISH"
_parse --no-build
expect '--no-build alone only fetches the prebuilt toolchain' download "$MODE"

test_section 'filc_parse_args -- --rebuild'

_parse
expect 'without --rebuild nothing is rebuilt from scratch' '' "$FILC_CLEAN_FILTER"
_parse --rebuild
expect 'bare --rebuild builds from source, every portion from scratch' 'source ^.*$' \
    "$MODE $FILC_CLEAN_FILTER"
_parse --rebuild=
expect 'an empty --rebuild= rebuilds every portion' '^.*$' "$FILC_CLEAN_FILTER"
_parse '--rebuild=crt|pas'
expect '--rebuild=<re> keeps the regexp' 'crt|pas' "$FILC_CLEAN_FILTER"
_parse --no-build --rebuild=pas --publish
expect '--rebuild after --no-build builds again' 'light 1' "$MODE $PUBLISH"
_parse --universal --rebuild=pas
expect '--rebuild keeps --universal' 'light static' "$MODE $STATIC"
_parse --rebuild=clang
expect 'rebuilding clang builds from source' source "$MODE"

test_section 'filc_parse_args -- --clean'

_parse --clean
expect 'bare --clean only cleans, every portion' 'clean ^.*$' "$MODE $FILC_CLEAN_FILTER"
_parse '--clean=crt|unwind'
expect '--clean=<re> keeps the regexp, over keywords' 'clean crt|unwind' "$MODE $FILC_CLEAN_FILTER"
_parse --clean=
expect 'an empty --clean= cleans every portion' '^.*$' "$FILC_CLEAN_FILTER"
_parse --clean=pas --nightly
expect '--clean with a build flag cleans, then builds' 'source pas' "$MODE $FILC_CLEAN_FILTER"
_parse --clean=pas --publish
expect '--clean with --publish cleans, then builds and publishes' 'light 1' "$MODE $PUBLISH"
_parse --nightly --clean=pas --no-build
expect '--clean --no-build only cleans' clean "$MODE"
_parse --rebuild=crt
expect '--rebuild sets the same filter as --clean' 'light crt' "$MODE $FILC_CLEAN_FILTER"
_parse --no-build --publish --no-publish
expect '--no-build --no-publish only fetches' download "$MODE"
_parse --export --publish
expect '--export --publish exports, then publishes' 'export 1' "$MODE $PUBLISH"
_parse --no-sync
expect '--no-sync turns syncing off' '0 ' "$SYNC $FILC_SYNC_FILTER"
_parse --sync=clang --no-sync
expect '--no-sync after --sync clears its filter too' '0 ' "$SYNC $FILC_SYNC_FILTER"
_parse --no-sync --sync=pas
expect '--sync after --no-sync turns syncing back on' '1 pas' "$SYNC $FILC_SYNC_FILTER"

test_section 'filc_parse_args -- --sync and the build folder'

_parse
expect 'without --sync no portion syncs early' '' "$FILC_SYNC_FILTER"
_parse --sync
expect 'bare --sync matches every portion' '^.*$' "$FILC_SYNC_FILTER"
_parse --sync=
expect 'an empty --sync= matches every portion' '^.*$' "$FILC_SYNC_FILTER"
_parse '--sync=clang|pas'
expect '--sync=<re> keeps the regexp' 'clang|pas' "$FILC_SYNC_FILTER"
_parse -d rel/dir
expect '-d makes a relative folder absolute' "$(pwd)/rel/dir" "$BUILD_DIR"
_parse --directory=/abs/dir
expect '--directory= keeps an absolute folder' /abs/dir "$BUILD_DIR"
unset BUILD_DIR
FILC_BUILD_DIR_SUFFIX=-x filc_parse_args
expect 'FILC_BUILD_DIR_SUFFIX extends the default folder' \
    "$(dirname "$ROOT")/build/$(basename "$ROOT")-x" "$BUILD_DIR"
expect_returns 'an unknown flag is a usage error' 2 filc_parse_args --bogus
expect_returns '-d without a value is a usage error' 2 filc_parse_args -d

test_section 'filc_parse_args -- --archs'

_host=$(filc_host_arch)
_other=$(for _a in $FILC_ARCHS; do [ "$_a" = "$_host" ] || { echo "$_a"; break; }; done)
_parse
expect 'by default only the host arch is built' "$_host" "$ARCHS"
_parse --archs=all
expect 'all names every arch Fil-C supports, the host first' "$_host $_other" "$ARCHS"
_parse "--archs=$_other,$_host"
expect 'a list is ordered host first' "$_host $_other" "$ARCHS"
_parse "--archs=all,host,$_host"
expect 'an arch named twice is built once' "$_host $_other" "$ARCHS"
_parse --arch=arm
expect '--arch is the same as --archs; arm means aarch64' aarch64 "$ARCHS"
for _n in arm64 armv8 armv8-a aarch64; do
    expect "$_n means aarch64" aarch64 "$(filc_arch_name "$_n")"
done
for _n in amd64 x64 x86-64 x86_64; do
    expect "$_n means x86_64" x86_64 "$(filc_arch_name "$_n")"
done
_parse --archs "$_other"
expect '--archs <list> takes the next argument' "$_other" "$ARCHS"
_parse --archs=
expect 'an empty --archs= is the host' "$_host" "$ARCHS"
_parse --archs=host
expect 'the host alone builds this tree' "light $_host" "$MODE $ARCHS"
_parse "--archs=$_other"
expect 'a foreign arch builds this tree too' light "$MODE"
_parse --archs=all --archs=host
expect 'a later --archs overrides an earlier one' "light $_host" "$MODE $ARCHS"
_parse --archs=all --clean=pas
expect 'with --clean alone each arch is only cleaned' "clean $_host $_other" "$MODE $ARCHS"
_parse --archs=all --no-build --publish
expect 'with --no-build --publish the archives in dist/ are published' upload "$MODE"
_parse --archs=all --export
expect 'with --export each arch is exported' 'export 0' "$MODE $PUBLISH"
for _n in armv7 armhf i686 riscv64; do
    expect_returns "$_n is refused" 2 filc_parse_args "--archs=$_n"
done
expect 'the refusal says Fil-C is 64-bit x86_64 and aarch64 only' 1 \
    "$( (filc_parse_args --archs=armv7) 2>&1 | grep -c 'supports only the 64-bit archs: x86_64, aarch64\.$')"
expect_returns '--archs without a value is a usage error' 2 filc_parse_args --archs

test_section 'filc_parse_args -- the libc slice, --install and --headless'

_parse
expect 'by default glibc, installed at /opt/fil, asking for root' 'glibc 1 ' "$LIBC $INSTALL $HEADLESS"
for _f in --gnu --glibc; do
    _parse --musl "$_f"
    expect "$_f picks glibc" glibc "$LIBC"
done
_parse --musl
expect '--musl picks musl' musl "$LIBC"
for _f in --no-install --no-setup; do
    _parse "$_f"
    expect "$_f leaves /opt/fil alone" 0 "$INSTALL"
    _parse "$_f" --setup
    expect "--setup after $_f installs again" 1 "$INSTALL"
done
_parse --headless
expect '--headless asks nothing' 1 "$HEADLESS"
_parse --prerequisites
expect '--prerequisites only fetches the prerequisites' prerequisites "$MODE"
_parse --install
expect '--install no longer means the prerequisites' light "$MODE"


# ---- specs: platform identity ---------------------------------------------

test_section 'filc_detect_platform'

filc_detect_platform
expect 'by default the arch is the host'"'"'s' "$_host" "$ARCH"
filc_detect_platform "$_other"
expect 'or the one given' "$_other" "$ARCH"
filc_detect_platform

test_section 'filc_use_arch / filc_llvm_targets'

HOST_BUILD_DIR=$_sb/ws; TOOLS=$_sb/tools
filc_use_arch "$_host"
expect 'the host arch builds natively in the build folder' "$_sb/ws||$_sb/ws/build" \
    "$BUILD_DIR|$CROSS|$(filc_clang_dir)"
filc_use_arch "$_other"
expect 'a foreign arch builds in <build folder>-<arch>, for <arch>-linux-gnu' \
    "$_sb/ws-$_other|$_other-linux-gnu|$_sb/tools/cross-$_other" "$BUILD_DIR|$CROSS|$XROOT"
expect 'its clang builds in clang-build/, beside the host clang of build/' \
    "$_sb/ws-$_other/clang-build" "$(filc_clang_dir)"
filc_use_arch "$_host"
mkdir -p "$_sb/tg"
expect 'a host clang gets the LLVM target of each arch' 'X86;AArch64' \
    "$(filc_llvm_targets "$_sb/tg" aarch64 x86_64)"
expect 'each target once' X86 "$(filc_llvm_targets "$_sb/tg" x86_64 x86_64)"
echo 'LLVM_TARGETS_TO_BUILD:STRING=AArch64' > "$_sb/tg/CMakeCache.txt"
expect 'the targets the cmake cache has are kept' 'X86;AArch64' "$(filc_llvm_targets "$_sb/tg" x86_64)"
expect 'without archs it prints the cached ones' AArch64 "$(filc_llvm_targets "$_sb/tg")"


# ---- specs: compiler repo, release URL, token ------------------------------

# _repo <dir> [<remote> <url>]...: a git repo at <dir> with the given remotes.
_repo() {
    _d=$1; shift
    rm -rf "$_d"; mkdir -p "$_d"
    git -C "$_d" init -q
    while [ $# -gt 1 ]; do git -C "$_d" remote add "$1" "$2"; shift 2; done
}

test_section 'filc_compiler_repo_slug / filc_release_base_urls'

ROOT=$_sb/tree
_slug_with() {   # $1 = submodule URL, [$2 = origin URL]
    _repo "$ROOT" ${2:+origin "$2"}
    printf '[submodule "compiler"]\n\tpath = compiler\n\turl = %s\n' "$1" > "$ROOT/.gitmodules"
    filc_compiler_repo_slug
}
expect 'an https URL gives <owner>/<repo>' owner/fil-c-llvm \
    "$(_slug_with https://github.com/owner/fil-c-llvm.git)"
expect 'an ssh URL gives <owner>/<repo>' owner/fil-c-llvm \
    "$(_slug_with git@github.com:owner/fil-c-llvm.git)"
expect 'a relative URL resolves against origin, dropping its token' owner/fil-c-llvm \
    "$(_slug_with ../fil-c-llvm.git https://TOKEN@github.com/owner/fil-c-light.git)"
expect 'a non-GitHub URL gives nothing' '' \
    "$(_slug_with https://example.com/owner/fil-c-llvm.git)"
_slug_with https://github.com/owner/fil-c-llvm.git > /dev/null
expect 'the release URLs are the compiler repo'"'"'s release of the upstream version, then its latest one' \
    'https://github.com/owner/fil-c-llvm/releases/download/v0.685 https://github.com/owner/fil-c-llvm/releases/latest/download' \
    "$(filc_release_base_urls | tr '\n' ' ' | sed 's/ $//')"
expect 'FILC_LIGHT_RELEASE_URL overrides them' https://mirror/x \
    "$(FILC_LIGHT_RELEASE_URL=https://mirror/x filc_release_base_urls)"

test_section 'filc_github_token -- found through git remote'

_repo "$ROOT" origin https://TREE@github.com/owner/fil-c-light.git
_repo "$ROOT/compiler" origin https://LLVM@github.com/owner/fil-c-llvm.git
expect "the compiler repo's own remote wins" LLVM "$(filc_github_token owner/fil-c-llvm)"
_repo "$ROOT/compiler" origin https://user:PAIR@github.com/owner/fil-c-llvm.git
expect 'a <user>:<token> URL gives the token' PAIR "$(filc_github_token owner/fil-c-llvm)"
_repo "$ROOT/compiler" origin git@github.com:owner/fil-c-llvm.git
expect 'else a remote of the same owner is used' TREE "$(filc_github_token owner/fil-c-llvm)"
expect 'a remote of another owner is never used' '' "$(filc_github_token other/fil-c-llvm)"
_repo "$ROOT" origin https://github.com/owner/fil-c-light.git
expect 'no token in any remote gives nothing' '' "$(filc_github_token owner/fil-c-llvm)"


# ---- specs: the prebuilt download ---------------------------------------------

test_section 'filc_download_toolchain -- on a fake release server'

# A curl stand-in serving the archives found under $_srv, by file name.
_srv=$_sb/srv
mkdir -p "$_srv"
curl() {
    local out="" url=""
    while [ $# -gt 0 ]; do
        case "$1" in -o) out=$2; shift ;; http*) url=$1 ;; esac
        shift
    done
    [ -f "$_srv/${url##*/}" ] && cp "$_srv/${url##*/}" "$out"
}
ROOT=$_sb/dl-tree; TOOLS=$_sb/dl-tools; ARCH=x86_64
mkdir -p "$ROOT/compiler/clang/lib/Basic"
_archive() {   # $1 = file name, $2 = text the fake clang prints (_NOSETUP: no setup.sh)
    local top=$_sb/pack/optfil-pkg
    rm -rf "$_sb/pack"
    mkdir -p "$_sb/pack/fil/bin" "$_sb/pack/fil/lib/clang/20" "$_sb/pack/fil/include/c++/v1" \
             "$_sb/pack/fil/include/x86_64-unknown-linux-gnu/c++/v1" "$_sb/pack/fil/share/locale" "$top"
    printf '#!/bin/sh\necho "%s"\n' "$2" > "$_sb/pack/fil/bin/filcc-clang-20"
    chmod +x "$_sb/pack/fil/bin/filcc-clang-20"
    ln -s filcc-clang-20 "$_sb/pack/fil/bin/filcc"
    : > "$_sb/pack/fil/bin/iconv"
    : > "$_sb/pack/fil/lib/libpizlo.so"
    : > "$_sb/pack/fil/include/stdio.h"
    : > "$_sb/pack/fil/include/c++/v1/vector"
    : > "$_sb/pack/fil/include/x86_64-unknown-linux-gnu/c++/v1/__config_site"
    tar -C "$_sb/pack" -cJf "$top/fil.tar.xz" fil
    if [ -z "${_NOSETUP:-}" ]; then printf '#!/bin/sh\n' > "$top/setup.sh"; chmod +x "$top/setup.sh"; fi
    tar -C "$_sb/pack" -cJf "$_srv/$1" optfil-pkg
}
_no_url_download() {   # no env URL and no GitHub compiler repo
    unset FILC_LIGHT_RELEASE_URL
    filc_compiler_repo_slug() { :; }
    filc_download_toolchain
}
expect_returns 'with no release URL it gives up' 1 _no_url_download
export FILC_LIGHT_RELEASE_URL=https://srv/dl
expect_returns 'with no archive for the version and arch it gives up' 1 filc_download_toolchain
_archive optfil-0.684-linux-x86_64.xz other
expect_returns 'an archive of another version does not serve' 1 filc_download_toolchain
_archive optfil-0.685-linux-x86_64.xz prebuilt
rm -rf "$ROOT/build" "$ROOT/pizfix"
expect_returns 'the optfil archive of the upstream version and arch serves' 0 filc_download_toolchain
expect 'its clang lands in build/bin, as clang and clang++ too' 'prebuilt prebuilt' \
    "$("$ROOT/build/bin/clang") $("$ROOT/build/bin/clang++")"
expect 'its resource folder and libc++ headers land in build/' 'yes yes yes' \
    "$([ -d "$ROOT/build/lib/clang/20" ] && echo yes) $([ -f "$ROOT/build/include/c++/v1/vector" ] && echo yes) $([ -f "$ROOT/build/include/x86_64-unknown-linux-gnu/c++/v1/__config_site" ] && echo yes)"
expect 'everything else lands in pizfix/' 'yes yes yes yes' \
    "$([ -f "$ROOT/pizfix/lib/libpizlo.so" ] && echo yes) $([ -f "$ROOT/pizfix/include/stdio.h" ] && echo yes) $([ -f "$ROOT/pizfix/bin/iconv" ] && echo yes) $([ -d "$ROOT/pizfix/share/locale" ] && echo yes)"
expect 'the links to the moved clang are dropped' '' "$(ls "$ROOT/pizfix/bin/filcc" 2>/dev/null)"
expect 'its clang is marked as a Fil-C-Light one, beside its bin/, with both versions and its libc' \
    '[Version]|light=1.0.0|upstream=0.685|libc=glibc' \
    "$(tr '\n' '|' < "$ROOT/build/share/fil-c-light.ini" 2>/dev/null | sed 's/|$//')"
expect 'the downloaded archive and its unpacking are not kept' '' "$(ls "$TOOLS" 2>/dev/null)"
echo garbage > "$_srv/optfil-0.685-linux-x86_64.xz"
rm -rf "$ROOT/build" "$ROOT/pizfix"
expect_returns 'a broken archive fails the download' 1 filc_download_toolchain
expect 'and lays nothing out' '' "$(ls "$ROOT/build/bin" 2>/dev/null)"
_archive optfil-0.685-linux-x86_64.xz prebuilt
# With no URL given, the release of the upstream version first, then the latest one.
_tries=$_sb/tries
_try_run() {   # $1 = the base URL that has the package
    (
        unset FILC_LIGHT_RELEASE_URL
        filc_compiler_repo_slug() { echo owner/fil-c-llvm; }
        curl() {
            local out="" url=""
            while [ $# -gt 0 ]; do case "$1" in -o) out=$2; shift ;; http*) url=$1 ;; esac; shift; done
            echo "$url" >> "$_tries"
            [ "${url%/*}" = "$_has" ] && cp "$_srv/${url##*/}" "$out"
        }
        _has=$1; : > "$_tries"
        rm -rf "$ROOT/build" "$ROOT/pizfix"
        filc_download_toolchain > /dev/null 2>&1; echo "exit@$?"
    )
}
expect 'it takes the release of its upstream version when that has the package' \
    'exit@0|https://github.com/owner/fil-c-llvm/releases/download/v0.685/optfil-0.685-linux-x86_64.xz' \
    "$(_try_run https://github.com/owner/fil-c-llvm/releases/download/v0.685)|$(tr '\n' ' ' < "$_tries" | sed 's/ $//')"
expect 'else it tries the latest release after it' \
    'exit@0|https://github.com/owner/fil-c-llvm/releases/download/v0.685/optfil-0.685-linux-x86_64.xz https://github.com/owner/fil-c-llvm/releases/latest/download/optfil-0.685-linux-x86_64.xz' \
    "$(_try_run https://github.com/owner/fil-c-llvm/releases/latest/download)|$(tr '\n' ' ' < "$_tries" | sed 's/ $//')"
test_section 'filc_light_version / filc_upstream_version -- from the tags'

_pinned=$(declare -f filc_light_version filc_upstream_version)
eval "$_versions"

_tv=$_sb/tv
rm -rf "$_tv"; mkdir -p "$_tv"
git -C "$_tv" init -q
git -C "$_tv" -c user.name=t -c user.email=t@t commit -q --allow-empty -m one
git -C "$_tv" tag 1.0.0; git -C "$_tv" tag upstream-0.685; git -C "$_tv" tag notes
git -C "$_tv" -c user.name=t -c user.email=t@t commit -q --allow-empty -m two
git -C "$_tv" tag 1.2.0; git -C "$_tv" tag upstream-0.686
git -C "$_tv" -c user.name=t -c user.email=t@t commit -q --allow-empty -m three
expect 'the nearest version tag and upstream-<version> tag before HEAD give both versions' '1.2.0 0.686' \
    "$(ROOT=$_tv; echo "$(filc_light_version) $(filc_upstream_version)")"
expect 'outside a checkout they default' '1.0.0 0.680' \
    "$(ROOT=$_sb/no-such-tree; echo "$(filc_light_version) $(filc_upstream_version)")"
# No git: filc_find_git finds none for this test, and is restored after it.
_find_git=$(declare -f filc_find_git)
filc_find_git() { return 1; }
expect 'and so they do without git' '1.0.0 0.680' \
    "$(ROOT=$_tv; echo "$(filc_light_version) $(filc_upstream_version)")"
eval "$_find_git"
unset _find_git
expect 'with git found again the tags count again' '1.2.0 0.686' \
    "$(ROOT=$_tv; echo "$(filc_light_version) $(filc_upstream_version)")"
eval "$_pinned"
unset _pinned

test_section 'filc_download_install -- the prebuilt toolchain at /opt/fil, by its setup.sh'

_di_run() {
    (
        _log=$_sb/di.log; : > "$_log"
        sudo() {   # records the command, and the folder setup.sh runs in
            case "$1" in ./setup.sh) echo "sudo $* @${PWD##*/}" ;; *) echo "sudo $*" ;; esac >> "$_log"
        }
        filc_download_install > /dev/null 2>&1
        echo "exit@$?" >> "$_log"
        cat "$_log"
    )
}
_archive optfil-0.685-linux-x86_64.xz prebuilt
expect 'it empties /opt/fil, then runs the package'"'"'s setup.sh unattended in its folder' \
    'sudo rm -rf /opt/fil|sudo ./setup.sh --unattended @optfil-pkg|exit@0' \
    "$(_di_run | tr '\n' '|' | sed 's/|$//')"
expect 'and keeps neither the archive nor its unpacking' '' "$(ls "$TOOLS" 2>/dev/null)"
_NOSETUP=1 _archive optfil-0.685-linux-x86_64.xz prebuilt
expect 'a package with no setup.sh leaves /opt/fil alone' 'exit@1' "$(_di_run | tr '\n' '|' | sed 's/|$//')"
echo garbage > "$_srv/optfil-0.685-linux-x86_64.xz"
expect 'so does a broken archive' 'exit@1' "$(_di_run | tr '\n' '|' | sed 's/|$//')"
rm -f "$_srv"/optfil-*.xz
expect 'with no package to fetch it touches nothing' 'exit@1' "$(_di_run | tr '\n' '|' | sed 's/|$//')"
unset FILC_LIGHT_RELEASE_URL
unset -f curl


# ---- specs: the build-folder mirror ----------------------------------------

test_section 'filc_mirror -- the build folder'

ROOT=$_sb/mirror-tree
BUILD_DIR=$_sb/mirror-ws
rm -rf "$ROOT" "$BUILD_DIR"
mkdir -p "$ROOT/.git" "$ROOT/libpas" "$ROOT/compiler/llvm" "$ROOT/filc/include" \
         "$ROOT/pizfix/lib" "$ROOT/build/bin" "$ROOT/dist" "$ROOT/tmp-build"
echo src > "$ROOT/libpas/x.c"
echo run > "$ROOT/build_runtime.sh"
: > "$ROOT/compiler/llvm/CMakeLists.txt"
: > "$ROOT/filc/include/stdfil.h"
echo tree > "$ROOT/pizfix/lib/libpizlo.so"
: > "$ROOT/build/bin/clang-20"
: > "$ROOT/dist/a.xz"
ln -s compiler/llvm "$ROOT/llvm"
filc_mirror
expect 'compiler/ is linked, not copied' "$ROOT/compiler" "$(readlink "$BUILD_DIR/compiler")"
expect 'filc/ is linked, not copied' "$ROOT/filc" "$(readlink "$BUILD_DIR/filc")"
expect 'llvm resolves through the linked compiler/' yes \
    "$([ -f "$BUILD_DIR/llvm/CMakeLists.txt" ] && echo yes)"
expect 'what upstream writes into is copied' 'src file' \
    "$(cat "$BUILD_DIR/libpas/x.c") $([ -L "$BUILD_DIR/libpas" ] && echo link || echo file)"
expect 'build/, dist/, tmp-build/ and .git are left out' '' \
    "$(ls -d "$BUILD_DIR/build" "$BUILD_DIR/dist" "$BUILD_DIR/tmp-build" "$BUILD_DIR/.git" 2>/dev/null)"
expect "pizfix/ starts as a copy of the tree's" tree "$(cat "$BUILD_DIR/pizfix/lib/libpizlo.so")"
echo built > "$BUILD_DIR/libpas/x.o"
echo ws > "$BUILD_DIR/pizfix/lib/libpizlo.so"
echo src2 > "$ROOT/libpas/x.c"
filc_mirror
expect 'a later mirror keeps earlier build output' built "$(cat "$BUILD_DIR/libpas/x.o")"
expect 'a later mirror brings changed sources' src2 "$(cat "$BUILD_DIR/libpas/x.c")"
expect "a later mirror keeps the build folder's own pizfix/" ws \
    "$(cat "$BUILD_DIR/pizfix/lib/libpizlo.so")"
expect 'the mirror never touches the tree' tree "$(cat "$ROOT/pizfix/lib/libpizlo.so")"
echo asm > "$ROOT/libpas/y.S"
filc_mirror
rm "$ROOT/libpas/y.S"
filc_mirror
expect 'a source the tree deleted is removed from the build folder too' no \
    "$([ -e "$BUILD_DIR/libpas/y.S" ] && echo yes || echo no)"
expect 'while build output stays' built "$(cat "$BUILD_DIR/libpas/x.o")"
expect 'as do the folders the mirror leaves out' 'ws yes' \
    "$(cat "$BUILD_DIR/pizfix/lib/libpizlo.so") $([ -L "$BUILD_DIR/compiler" ] && echo yes)"


# ---- specs: syncing built portions into the tree ---------------------------

test_section 'filc_sync_* -- the tree changes only when asked'

# _sync_case <filter>: a tree and build folder where clang, pas and libc were
# rebuilt; prints "<clang> <pizlo> <libc> <old-time>" of the tree before and after
# filc_sync_all, separated by " | ".
_sync_case() {
    ROOT=$_sb/sync-tree; BUILD_DIR=$_sb/sync-ws
    rm -rf "$ROOT" "$BUILD_DIR"
    mkdir -p "$ROOT/build/bin" "$ROOT/build/lib/clang" "$ROOT/pizfix/lib" \
             "$BUILD_DIR/build/bin" "$BUILD_DIR/build/lib/clang"
    echo old > "$ROOT/build/bin/clang-20"
    echo old > "$ROOT/pizfix/lib/libpizlo.so"
    echo old > "$ROOT/pizfix/lib/libc.so.6666"
    cp -a "$ROOT/pizfix" "$BUILD_DIR/pizfix"
    FILC_SYNC_FILTER=$1; BUILT=""; SYNCED=""
    echo new > "$BUILD_DIR/build/bin/clang-20"
    BUILT="$BUILT clang"; filc_sync_portion clang > /dev/null
    sleep 1
    filc_portion pas sh -c 'echo new > pizfix/lib/libpizlo.so' > /dev/null
    filc_portion libc sh -c 'echo new > pizfix/lib/libc.so.6666;
        echo new > pizfix/lib/old-time.so; touch -d 2000-01-01 pizfix/lib/old-time.so' > /dev/null
    _state() {
        printf '%s %s %s %s' "$(cat "$ROOT/build/bin/clang-20")" \
            "$(cat "$ROOT/pizfix/lib/libpizlo.so")" "$(cat "$ROOT/pizfix/lib/libc.so.6666")" \
            "$(cat "$ROOT/pizfix/lib/old-time.so" 2>/dev/null || echo none)"
    }
    printf '%s | ' "$(_state)"
    filc_sync_all > /dev/null
    _state
}
expect 'without --sync nothing changes until the entire build is done' \
    'old old old none | new new new new' "$(_sync_case '')"
expect '--sync=clang|pas updates only those portions early' \
    'new new old none | new new new new' "$(_sync_case 'clang|pas')"
expect 'bare --sync (^.*$) updates every portion early' \
    'new new new none | new new new new' "$(_sync_case '^.*$')"
expect 'no temporary sync files are left behind' 0 \
    "$(find "$_sb/sync-tree" -name '*.filc-sync.*' -o -name '*.filc-old.*' | wc -l | tr -d ' ')"
expect 'filc_portion lists the pizfix/ files a portion wrote' pizfix/lib/libpizlo.so \
    "$(cat "$_sb/sync-ws/.filc-portions/pas.list")"
FILC_SYNC_FILTER=''
expect_returns 'filc_sync_filter passes nothing without a filter' 1 filc_sync_filter clang
FILC_SYNC_FILTER='^(clang|pas)$'
expect_returns 'filc_sync_filter passes a matching keyword' 0 filc_sync_filter pas
expect_returns 'filc_sync_filter blocks another keyword' 1 filc_sync_filter libc
ROOT=$_sb/sync-tree; BUILD_DIR=$_sb/sync-ws
echo blocked > "$BUILD_DIR/pizfix/lib/libc.so.6666"
filc_sync_file libc pizfix/lib/libc.so.6666
expect 'filc_sync_file is a no-op for a blocked portion' new "$(cat "$ROOT/pizfix/lib/libc.so.6666")"
filc_sync_file pas pizfix/lib/libc.so.6666
expect 'filc_sync_file copies for a passed portion' blocked "$(cat "$ROOT/pizfix/lib/libc.so.6666")"


test_section 'filc_portion -- only what changed builds'

ROOT=$_sb/keep-tree; BUILD_DIR=$_sb/keep-ws; FILC_CLEAN_FILTER=''; FILC_SYNC_FILTER=''
rm -rf "$ROOT" "$BUILD_DIR"
mkdir -p "$ROOT/libpas" "$BUILD_DIR/pizfix/lib"
echo src > "$ROOT/libpas/x.c"
_pas() { filc_portion pas sh -c 'echo built >> pizfix/lib/libpizlo.so' | grep -c '^===== pas: unchanged'; }
expect 'a portion that never built here builds' 0 "$(_pas)"
expect 'one whose sources did not change since is kept' '1 built' \
    "$(_pas) $(cat "$BUILD_DIR/pizfix/lib/libpizlo.so")"
sleep 1; echo src2 > "$ROOT/libpas/x.c"
expect 'a changed source builds it again' '0 2' \
    "$(_pas) $(wc -l < "$BUILD_DIR/pizfix/lib/libpizlo.so" | tr -d ' ')"
rm "$BUILD_DIR/pizfix/lib/libpizlo.so"
expect 'and so does a file it installed that is gone' 0 "$(_pas)"
FILC_CLEAN_FILTER=pas
expect '--rebuild of it builds it whatever changed' 0 "$(filc_clean_portion() { :; }; _pas)"
FILC_CLEAN_FILTER=''
expect 'a portion with no known sources always builds' '0 0' \
    "$(filc_portion xtest true | grep -c '^===== xtest: unchanged') $(filc_portion xtest true | grep -c '^===== xtest: unchanged')"


test_section 'filc_clean_portion / --rebuild -- from scratch'

BUILD_DIR=$_sb/rebuild-ws
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/build/bin" "$BUILD_DIR/compiler-rt/build" "$BUILD_DIR/yolounwind" "$BUILD_DIR/pizfix"
: > "$BUILD_DIR/build/bin/clang-20"
: > "$BUILD_DIR/compiler-rt/build/x.o"
: > "$BUILD_DIR/yolounwind/yolounwind.o"; : > "$BUILD_DIR/yolounwind/libyolounwind.a"
echo src > "$BUILD_DIR/yolounwind/yolounwind.c"
FILC_CLEAN_FILTER='^unwind$'
filc_portion crt sh -c 'true' > /dev/null
expect 'a portion the filter does not match keeps its build output' yes \
    "$([ -f "$BUILD_DIR/compiler-rt/build/x.o" ] && echo yes)"
filc_portion unwind sh -c 'true' > /dev/null
expect 'a matched portion starts from scratch, sources kept' 'gone src' \
    "$(ls "$BUILD_DIR"/yolounwind/*.o "$BUILD_DIR"/yolounwind/*.a 2>/dev/null || echo gone) $(cat "$BUILD_DIR/yolounwind/yolounwind.c")"
filc_clean_portion crt > /dev/null
expect 'crt from scratch drops compiler-rt/build' gone \
    "$([ -e "$BUILD_DIR/compiler-rt/build" ] && echo kept || echo gone)"
filc_clean_portion clang > /dev/null
expect 'clang from scratch drops the whole LLVM build' gone \
    "$([ -e "$BUILD_DIR/build" ] && echo kept || echo gone)"
mkdir -p "$BUILD_DIR/pizlonated-yolo-glibc-build" "$BUILD_DIR/pizlonated-user-glibc-build" \
         "$BUILD_DIR/libpas/build"
for _kw in yolo libc pas; do filc_clean_portion "$_kw" > /dev/null; done
expect 'yolo, libc and pas drop their build folders' '' \
    "$(ls -d "$BUILD_DIR/pizlonated-yolo-glibc-build" "$BUILD_DIR/pizlonated-user-glibc-build" "$BUILD_DIR/libpas/build" 2>/dev/null)"
expect 'cleaning never touches the installed pizfix/' yes "$([ -d "$BUILD_DIR/pizfix" ] && echo yes)"
FILC_CLEAN_FILTER=''


# ---- specs: clang linkage checks ---------------------------------------------

test_section 'filc_clang_is_universal / filc_clang_glibc_floor'

_cc=$(command -v clang || command -v cc || true)
_cxx=$(command -v clang++ || command -v c++ || true)
if [ -n "$_cc" ] && [ -n "$_cxx" ]; then
    echo 'int main(void) { return 0; }' > "$_sb/c.c"
    printf '#include <string>\nint main() { return std::string("x").size() - 1; }\n' > "$_sb/cxx.cpp"
    "$_cc" -o "$_sb/c" "$_sb/c.c" 2>/dev/null
    "$_cxx" -o "$_sb/cxx" "$_sb/cxx.cpp" 2>/dev/null
    "$_cxx" -static-libstdc++ -static-libgcc -o "$_sb/cxx-static" "$_sb/cxx.cpp" 2>/dev/null
    expect_returns 'a C binary counts as universal' 0 filc_clang_is_universal "$_sb/c"
    expect_returns 'a C++ binary using the shared libstdc++ does not' 1 filc_clang_is_universal "$_sb/cxx"
    if [ -x "$_sb/cxx-static" ]; then
        expect_returns 'a C++ binary with static libstdc++/libgcc does' 0 \
            filc_clang_is_universal "$_sb/cxx-static"
    else
        test_skip 'a C++ binary with static libstdc++/libgcc does' 'no static libstdc++ on this host'
    fi
    expect 'the glibc floor is a version number' yes \
        "$(filc_clang_glibc_floor "$_sb/c" | grep -qE '^[0-9]+\.[0-9]+' && echo yes)"
else
    test_skip 'clang linkage checks' 'no host C and C++ compiler'
fi


# ---- specs: publishing -------------------------------------------------------

test_section 'filc_asset_description / the release page text'

ARCH=x86_64
expect 'an optfil package is the glibc /opt/fil distribution, its clang on its own glibc' \
    'Linux x86_64, glibc, installed at /opt/fil (sudo ./setup.sh --unattended); its clang runs on its own glibc' \
    "$(filc_asset_description optfil-0.685-linux-x86_64.xz)"
filc_clang_glibc_floor() { echo 2.38; }
expect 'a filc- package is the musl one, with the host glibc its clang needs' \
    'Linux aarch64, musl, usable wherever it is unpacked (./setup.sh); its clang runs on a host glibc >= 2.38' \
    "$(filc_asset_description filc-0.685-linux-aarch64.xz)"
filc_clang_glibc_floor() { :; }
expect 'without a known floor it names no host glibc' 'Linux x86_64, musl, usable wherever it is unpacked (./setup.sh)' \
    "$(filc_asset_description filc-0.685-linux-x86_64.xz)"
expect 'any other name says its arch only' 'Linux x86_64' "$(filc_asset_description other-x86_64.xz)"

_page() {   # the release is the latest one unless _OLDER says otherwise
    local r="$1"; shift
    printf '%s' "$r" | FILC_LIGHT_VERSION=1.0.0 FILC_RELEASE_LATEST="$([ -n "${_OLDER:-}" ] || echo 1)" \
        FILC_NAMING_URL=https://github.com/owner/fil-c-llvm#release-naming \
        python3 -c "$FILC_PAGE_PY" 0.685 "$@"
}
_rel='{"name": "", "body": "", "assets": [
  {"name": "optfil-0.685-linux-x86_64.xz", "label": "Linux x86_64, glibc, an old label"},
  {"name": "filc-0.685-linux-aarch64.xz", "label": ""}]}'
_out=$(_page "$_rel")
_body=$(printf '%s' "$_out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["body"])')
expect 'the page names the release after both versions, nothing else' 'Fil-C-Light 1.0.0 (upstream 0.685)' \
    "$(printf '%s' "$_out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])')"
expect 'each asset is listed in name order, by an old label, else by its name' \
    "- \`filc-0.685-linux-aarch64.xz\`: Linux aarch64
- \`optfil-0.685-linux-x86_64.xz\`: Linux x86_64, glibc, an old label" \
    "$(printf '%s\n' "$_body" | grep '^- `')"
expect 'it opens with the versions alone' 'Prebuilt Fil-C-Light 1.0.0 toolchain packages, based on upstream Fil-C 0.685.' \
    "$(printf '%s\n' "$_body" | head -1)"
expect 'the latest release ends with the naming, as the README has it' \
    "We reuse upstream's naming where possible:|yes|no" \
    "$(printf '%s\n' "$_body" | grep "^We reuse")|$(printf '%s\n' "$_body" | grep -q '^- \*\*`optfil-\*`\*\* is the prefix for `glibc`' && echo yes)|$(printf '%s\n' "$_body" | grep -q 'build.sh. fetches' && echo yes || echo no)"
expect 'an older release links to the README'"'"'s naming section instead' \
    'See [Release Naming](https://github.com/owner/fil-c-llvm#release-naming) for what the package names mean.|no' \
    "$(_OLDER=1 _page "$_rel" | python3 -c 'import json,sys; print(json.load(sys.stdin)["body"].split("\n")[-1])')|$(_OLDER=1 _page "$_rel" | grep -q 'We reuse' && echo yes || echo no)"
_same=$(printf '%s' "$_out" | python3 -c '
import json, sys
p = json.load(sys.stdin); r = json.loads(sys.argv[1]); r.update(p); print(json.dumps(r))' "$_rel")
expect 'an up-to-date page asks for no change' '' "$(_page "$_same")"
_rel2='{"name": "", "body": "", "assets": [{"name": "optfil-0.685-linux-x86_64.xz", "label": ""},
  {"name": "optfil-0.685-linux-aarch64.xz", "label": ""}]}'
expect 'the name stays the versions alone, whatever archs its assets are for' 'Fil-C-Light 1.0.0 (upstream 0.685)' \
    "$(_page "$_rel2" | python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])')"
_rel3='{"name": "", "body": "Assets:\n- `optfil-0.685-linux-x86_64.xz`: Linux x86_64, kept\n- `optfil-0.685-linux-aarch64.xz`: old text", "assets": [
  {"name": "optfil-0.685-linux-x86_64.xz", "label": "optfil-0.685-linux-x86_64.xz"},
  {"name": "optfil-0.685-linux-aarch64.xz", "label": "optfil-0.685-linux-aarch64.xz"}]}'
expect 'the description given for the published asset wins; the others keep their line' \
    "- \`optfil-0.685-linux-aarch64.xz\`: Linux aarch64, glibc, new text
- \`optfil-0.685-linux-x86_64.xz\`: Linux x86_64, kept" \
    "$(_page "$_rel3" optfil-0.685-linux-aarch64.xz 'Linux aarch64, glibc, new text' \
       | python3 -c 'import json,sys; print(json.load(sys.stdin)["body"])' | grep '^- `')"

test_section 'filc_upload_archive -- on a fake GitHub'

# A curl stand-in that serves one release from $_gh/release.json, and logs every
# command line it gets to $_gh/argv.log.
_gh=$_sb/gh
mkdir -p "$_gh"
cat > "$_gh/fake.py" <<'PY'
import json, os, sys, hashlib, urllib.parse
state = os.path.join(os.path.dirname(sys.argv[0]), "release.json")
args = sys.argv[1:]
method, data, quiet, url = "GET", None, False, ""
i = 0
while i < len(args):
    a = args[i]
    if a == "-X": method = args[i + 1]; i += 1
    elif a == "--data-binary":
        src = args[i + 1]; i += 1
        data = sys.stdin.buffer.read() if src == "@-" else open(src[1:], "rb").read()
        if method == "GET": method = "POST"
    elif a == "-o": quiet = args[i + 1] == "/dev/null"; i += 1
    elif a.startswith("http"): url = a
    i += 1
rel = json.load(open(state)) if os.path.exists(state) else None
def save(): json.dump(rel, open(state, "w"))
def reply(obj):
    if not quiet: print(json.dumps(obj))
path = urllib.parse.urlparse(url)
if "/releases/tags/" in path.path:
    reply(rel if rel else {"message": "Not Found"})
elif path.path.endswith("/releases") and method == "POST":
    rel = {"id": 7, "tag_name": json.loads(data)["tag_name"], "name": "", "body": "", "assets": []}
    save(); reply(rel)
elif "/releases/assets/" in path.path:
    aid = int(path.path.rsplit("/", 1)[1])
    if method == "DELETE": rel["assets"] = [a for a in rel["assets"] if a["id"] != aid]
    elif method == "PATCH":
        for a in rel["assets"]:
            if a["id"] == aid: a.update(json.loads(data))
    save()
elif path.netloc == "uploads.github.com":
    q = urllib.parse.parse_qs(path.query)
    rel["assets"].append({"id": 100 + len(rel["assets"]) + int(rel.get("n", 0)),
                          "name": q["name"][0], "label": q.get("label", [""])[0],
                          "digest": "sha256:" + hashlib.sha256(data).hexdigest()})
    rel["n"] = rel.get("n", 0) + 1
    save()
elif path.path.endswith("/releases/7"):
    if method == "PATCH": rel.update(json.loads(data)); save()
    else: reply(rel)
PY
curl() { printf '%s\n' "$*" >> "$_gh/argv.log"; python3 "$_gh/fake.py" "$@"; }
_rel_get() { python3 -c "import json,sys; r=json.load(open('$_gh/release.json')); print($1)"; }

ROOT=$_sb/pub-tree; BUILD_DIR=$_sb/pub-ws; DIST=$ROOT/dist
_repo "$ROOT" origin https://github.com/owner/fil-c-light.git
printf '[submodule "compiler"]\n\tpath = compiler\n\turl = https://github.com/owner/fil-c-llvm.git\n' \
    > "$ROOT/.gitmodules"
_repo "$ROOT/compiler" origin https://SECRET-TOKEN@github.com/owner/fil-c-llvm.git
mkdir -p "$DIST" "$BUILD_DIR/build/bin"
printf '#!/bin/sh\necho "clang version 20.1.8 (Fil-C 0.685 https://github.com/owner/fil-c-llvm.git abc)"\n' \
    > "$BUILD_DIR/build/bin/clang-20"
chmod +x "$BUILD_DIR/build/bin/clang-20"
echo one > "$DIST/optfil-0.685-linux-x86_64.xz"

_log=$(filc_upload_archive optfil-0.685-linux-x86_64.xz 2>&1)
expect 'a missing release is created' 1 "$(printf '%s\n' "$_log" | grep -c '^publish: creating release v0.685')"
expect 'the archive is uploaded with its file name as its label' \
    'optfil-0.685-linux-x86_64.xz|optfil-0.685-linux-x86_64.xz' \
    "$(_rel_get '"|".join([r["assets"][0]["name"], r["assets"][0]["label"]])')"
expect 'the page is regenerated from the assets, with its description' 'Fil-C-Light 1.0.0 (upstream 0.685) yes' \
    "$(_rel_get 'r["name"] + (" yes" if "- `optfil-0.685-linux-x86_64.xz`: Linux x86_64, glibc, installed at /opt/fil (sudo ./setup.sh --unattended); its clang runs on its own glibc" in r["body"] else " no")')"
_log=$(filc_upload_archive optfil-0.685-linux-x86_64.xz 2>&1)
expect 'an identical asset is kept, only relabelled' '1 1' \
    "$(printf '%s\n' "$_log" | grep -c 'same sha256'; ) $(_rel_get 'len(r["assets"])')"
expect 'an unchanged page is left alone' 1 \
    "$(printf '%s\n' "$_log" | grep -c 'is up to date')"
echo two > "$DIST/optfil-0.685-linux-x86_64.xz"
_log=$(filc_upload_archive optfil-0.685-linux-x86_64.xz 2>&1)
expect 'a different archive replaces the older asset' "1 1 sha256:$(sha256sum "$DIST/optfil-0.685-linux-x86_64.xz" | cut -d' ' -f1)" \
    "$(printf '%s\n' "$_log" | grep -c 'replacing the older') $(_rel_get 'str(len(r["assets"])) + " " + r["assets"][0]["digest"]')"
expect 'the token never appears on a curl command line' 0 \
    "$(grep -c SECRET-TOKEN "$_gh/argv.log")"
expect 'no token header file is left behind' 0 \
    "$(grep -o -- '-H @[^ ]*' "$_gh/argv.log" | sed 's/-H @//' | sort -u | while read -r f; do [ -e "$f" ] && echo "$f"; done | wc -l | tr -d ' ')"
git -C "$ROOT/compiler" remote set-url origin https://github.com/owner/fil-c-llvm.git
git -C "$ROOT" remote set-url origin https://github.com/owner/fil-c-light.git
expect_returns 'without a token publishing is skipped, not failed' 0 \
    filc_upload_archive optfil-0.685-linux-x86_64.xz
expect 'and it says why' 1 \
    "$(filc_upload_archive optfil-0.685-linux-x86_64.xz 2>&1 | grep -c 'carries an access token; skipping')"
unset -f curl


# ---- specs: what a build runs ---------------------------------------------------

test_section 'filc_main -- the steps a from-source build runs'

# Every build step stubbed: each one only says its name; packing writes a small, valid
# archive unless _PACK says otherwise (none: writes nothing, bad: writes a non-xz file).
_steps_run() {
    (
        filc_install_bison() { :; }
        filc_mirror() {
            mkdir -p "$BUILD_DIR/pizfix/lib"; rm -f "$BUILD_DIR"/pizfix/lib/*
            # shellcheck disable=SC2086
            ( cd "$BUILD_DIR/pizfix/lib" && touch libpizlo.so libc.so.6666 libc++.so )
        }
        filc_build_clang() { echo clang; }
        filc_build_runtime_libc() { echo runtime; }
        filc_runtime_env() { :; }
        filc_build_cxx() { echo cxx; }
        filc_cxx_built() { :; }
        filc_sync_all() { echo sync; }
        filc_upload_archive() { echo publish; }
        filc_download_toolchain() { return 1; }
        # The /opt/fil package: built under the build folder (faked here, written as
        # _PACK says), then moved, checked and published by the real filc_optfil_dist.
        filc_optfil_package() {
            [ -z "$NOXZ" ] || return 0
            echo pack
            mkdir -p "$BUILD_DIR/optfil"
            case "${_PACK:-}" in
                none) ;;
                bad)  echo garbage > "$BUILD_DIR/optfil/optfil-0.685-linux-$ARCH.xz" ;;
                *)    printf x | xz > "$BUILD_DIR/optfil/optfil-0.685-linux-$ARCH.xz" ;;
            esac
            filc_optfil_dist "$1"
        }
        BUILD_DIR=$_sb/steps-ws; DIST=$_sb/steps-dist; TOOLS=$_sb/steps-tools
        filc_main --no-install "$@"
    )
}
_steps() {
    _steps_run "$@" 2>/dev/null | grep -E '^(clang|runtime|cxx|sync|pack|publish)$' | tr '\n' ' ' | sed 's/ $//'
}
expect 'by default a build syncs and packs, without publishing' 'clang runtime sync pack' "$(_steps --nightly)"
expect '--publish publishes too' 'clang runtime sync pack publish' "$(_steps --nightly --publish)"
expect '--no-sync leaves the tree alone' 'clang runtime pack' "$(_steps --nightly --no-sync)"
expect '--no-publish keeps the archive local' 'clang runtime sync pack' "$(_steps --nightly --no-publish)"
expect '--no-upload then --publish publishes' 'clang runtime sync pack publish' \
    "$(_steps --nightly --no-upload --publish)"
expect '--no-xz neither packs nor publishes' 'clang runtime sync' "$(_steps --nightly --no-xz)"
expect '--no-xz wins over --publish: nothing is packed, nothing published' 'clang runtime sync' \
    "$(_steps --nightly --no-xz --publish)"
expect_returns 'and that run still succeeds' 0 _steps_run --nightly --no-xz --publish
expect 'a bare --publish with no prebuilt toolchain builds from source, then publishes' \
    'clang runtime sync pack publish' \
    "$(_steps --publish)"
expect 'a universal build goes through the runtime portions too (each keeps itself when unchanged)' \
    'clang runtime sync pack publish' "$(_steps --nightly --universal --publish)"

test_section 'filc_main -- only a fresh, valid archive is published'

rm -rf "$_sb/steps-dist"
expect 'a pack that wrote nothing publishes nothing' 'clang runtime sync pack' "$(_PACK=none _steps --nightly)"
_PACK=none
expect_returns 'and the run fails' 1 _steps_run --nightly
unset _PACK
expect_returns 'a valid fresh archive lets the run succeed' 0 _steps_run --nightly
mkdir -p "$_sb/steps-dist"
printf x | xz > "$_sb/steps-dist/optfil-0.685-linux-$(uname -m).xz"
touch -d 2000-01-01 "$_sb/steps-dist"/*.xz
expect 'an archive older than the run is not published' 'clang runtime sync pack' "$(_PACK=none _steps --nightly)"
expect 'a corrupt archive is not published' 'clang runtime sync pack' "$(_PACK=bad _steps --nightly)"


test_section 'filc_main -- the default build: this tree, with the prebuilt clang'

# As _steps_run, with a prebuilt toolchain to fetch (unless _NOPREBUILT): its clang
# says "prebuilt"; the tree starts with an old toolchain, saying "old".
_light_run() {
    (
        filc_install_bison() { :; }
        filc_mirror() { mkdir -p "$BUILD_DIR/pizfix/lib"; }
        filc_build_clang() { echo clang; }
        filc_build_runtime_libc() { echo "runtime${1:+@$1}"; }
        filc_cxx_built() { :; }
        filc_optfil_package() { echo "pack@optfil"; [ "$PUBLISH" != 1 ] || echo "publish@optfil"; }
        filc_sync_all() { echo sync; }
        filc_upload_archive() { echo "publish@$1"; }
        filc_optfil_root() { echo root; [ -z "${_NOROOT:-}" ] || INSTALL=0; }
        filc_download_install() { [ -z "${_NOPREBUILT:-}" ] || return 1; echo "install@opt-fil"; }
        filc_download_toolchain() {
            [ -z "${_NOPREBUILT:-}" ] || return 1
            local d="${1:-$ROOT}"
            mkdir -p "$d/build/bin" "$d/build/lib/clang" "$d/pizfix/lib"
            printf '#!/bin/sh\necho prebuilt\n' > "$d/build/bin/clang-20"; chmod +x "$d/build/bin/clang-20"
            echo prebuilt > "$d/pizfix/lib/libpizlo.so"
            echo prebuilt > "$d/pizfix/lib/libc++.so"
            mkdir -p "$d/build/include/c++/v1"; echo prebuilt > "$d/build/include/c++/v1/vector"
            echo "fetch@$(basename "$d")"
        }
        ROOT=$_sb/lt-tree; BUILD_DIR=$_sb/lt-ws; DIST=$_sb/lt-dist; TOOLS=$_sb/lt-tools
        ( filc_main --no-install "$@" ); echo "exit@$?"
    ) 2>/dev/null | grep -E '^(clang|root|runtime.*|sync|pack@.*|publish@.*|fetch@.*|install@.*|exit@[1-9].*)$' | tr '\n' ' ' | sed 's/ $//'
}
_light_reset() {
    rm -rf "$_sb"/lt-*
    mkdir -p "$_sb/lt-tree/build/bin" "$_sb/lt-tree/pizfix/lib"
    echo old > "$_sb/lt-tree/build/bin/clang-20"; echo old > "$_sb/lt-tree/pizfix/lib/libpizlo.so"
}
_light_reset
expect 'it fetches the prebuilt toolchain, builds the runtime and syncs it; no clang build, no archive' \
    "fetch@prebuilt-$_host runtime@no-cxx sync" "$(_light_run)"
expect 'the tree got the prebuilt toolchain first' 'prebuilt prebuilt' \
    "$("$_sb/lt-tree/build/bin/clang-20") $(cat "$_sb/lt-tree/pizfix/lib/libpizlo.so")"
expect 'the build folder builds with the prebuilt clang, on the prebuilt runtime' 'prebuilt prebuilt' \
    "$("$_sb/lt-ws/build/bin/clang-20") $(cat "$_sb/lt-ws/pizfix/lib/libpizlo.so")"
expect 'the fetched archive is not kept' '' "$(ls "$_sb/lt-tools" 2>/dev/null | grep prebuilt)"
_light_reset
mkdir -p "$_sb/lt-ws/pizfix/lib"; echo stale > "$_sb/lt-ws/pizfix/lib/libpizlo.so"
_light_run > /dev/null
expect 'the whole prebuilt toolchain is laid down in the build folder, its libc++ and headers too' \
    'prebuilt prebuilt prebuilt' \
    "$(cat "$_sb/lt-ws/pizfix/lib/libpizlo.so" "$_sb/lt-ws/pizfix/lib/libc++.so" "$_sb/lt-ws/build/include/c++/v1/vector" | tr '\n' ' ' | sed 's/ $//')"
expect 'and in the tree' 'prebuilt prebuilt' \
    "$(cat "$_sb/lt-tree/pizfix/lib/libc++.so" "$_sb/lt-tree/build/include/c++/v1/vector" | tr '\n' ' ' | sed 's/ $//')"
_light_reset
expect 'with --publish it packs the /opt/fil package and publishes it' \
    "fetch@prebuilt-$_host runtime@no-cxx sync pack@optfil publish@optfil" \
    "$(_light_run --publish)"
_light_reset
expect '--no-sync leaves the tree alone' "fetch@prebuilt-$_host runtime@no-cxx" "$(_light_run --no-sync)"
expect 'even its toolchain' 'old old' \
    "$(cat "$_sb/lt-tree/build/bin/clang-20") $(cat "$_sb/lt-tree/pizfix/lib/libpizlo.so")"
_light_reset
mkdir -p "$_sb/lt-ws/build"; : > "$_sb/lt-ws/build/CMakeCache.txt"
expect 'a build folder that built its clang from source builds with it (libc++ too), and syncs it' \
    'clang runtime sync' "$(_light_run)"
expect 'and the tree keeps its toolchain until then' old "$(cat "$_sb/lt-tree/build/bin/clang-20")"
_light_reset
expect 'with no prebuilt toolchain it builds from source, still packing only to publish' \
    "clang runtime sync" "$(_NOPREBUILT=1 _light_run)"
_light_reset
expect '--no-build only fetches into the tree' 'fetch@lt-tree' "$(_light_run --no-build)"
expect 'and skips a foreign arch' 'fetch@lt-tree' "$(_light_run --no-build --archs=all)"
expect '--no-build fails with no prebuilt toolchain' exit@1 "$(_NOPREBUILT=1 _light_run --no-build)"
expect '--no-build with --install gets root and installs it at /opt/fil instead' 'root install@opt-fil' \
    "$(_light_run --no-build --install)"
expect 'and skips a foreign arch there too' 'root install@opt-fil' "$(_light_run --no-build --install --archs=all)"
expect 'with no root at hand (--headless) it fetches into the tree' 'root fetch@lt-tree' \
    "$(_NOROOT=1 _light_run --no-build --install --headless)"
expect '--no-build --install fails with no prebuilt toolchain' 'root exit@1' \
    "$(_NOPREBUILT=1 _light_run --no-build --install)"
expect '--no-build --musl fails: no prebuilt musl toolchain is published' 'exit@1' \
    "$(_light_run --no-build --install --musl)"


test_section '--musl -- its own build folder, the glibc one'"'"'s clang, upstream'"'"'s package'

_parse --musl
expect 'a musl build folder sits beside the glibc one' \
    "$(dirname "$ROOT")/build/$(basename "$ROOT")-musl $(dirname "$ROOT")/build/$(basename "$ROOT")" \
    "$BUILD_DIR $FILC_GLIBC_BUILD_DIR"
_parse --musl -d /x/ws
expect '-d still names it' /x/ws "$BUILD_DIR"
expect 'its yolo and user libc build from the musl sources' \
    'projects/yolomusl build_yolomusl.sh|projects/usermusl filc/include build_usermusl.sh' \
    "$(LIBC=musl filc_portion_sources yolo)|$(LIBC=musl filc_portion_sources libc)"
expect 'and run the musl scripts' 'yolo:bash ./build_yolomusl.sh libc:filc_build_user_musl' \
    "$( ( LIBC=musl; filc_runtime_env() { :; }; filc_portion() { echo "$1:${*:2}"; }; BUILD_DIR=$_sb/none
          filc_build_runtime_libc no-cxx ) | grep -E '^(yolo|libc):' | tr '\n' ' ' | sed 's/ $//')"
# The glibc build folder's clang, taken by a musl one.
_g=$_sb/mg-ws; rm -rf "$_g" "$_g-musl"; mkdir -p "$_g/build/bin" "$_g/build/lib/clang/20/include"
echo clang > "$_g/build/bin/clang-20"; : > "$_g/build/lib/clang/20/include/stddef.h"
_musl_clang() {
    ( LIBC=musl; FILC_GLIBC_BUILD_DIR=$_g; BUILD_DIR=$_g-musl; CROSS=""; ARCH=$_host
      FILC_SYNC_FILTER=''; BUILT=''; filc_borrow_clang; echo "built:$BUILT" ) 2>&1
}
_log=$(_musl_clang)
expect 'a musl build folder takes the glibc one'"'"'s clang, hard-linked, and its resource folder' \
    'clang 2 yes' \
    "$(cat "$_g-musl/build/bin/clang-20") $(stat -c %h "$_g-musl/build/bin/clang-20") $([ -f "$_g-musl/build/lib/clang/20/include/stddef.h" ] && echo yes)"
expect 'with the driver aliases' clang-20 "$(readlink "$_g-musl/build/bin/clang++")"
expect 'and counts it as built, for the tree to get it' 'built: clang' "$(printf '%s\n' "$_log" | tail -1)"
rm "$_g/build/bin/clang-20"
expect 'with no clang in the glibc folder it says to build that first' 1 \
    "$(_musl_clang | grep -c 'build the glibc toolchain of')"
# upstream's package-build.sh, faked: it leaves the package it names after the version.
_m=$_sb/musl-pkg-ws; DIST=$_sb/musl-dist; rm -rf "$_m" "$DIST"; mkdir -p "$_m/3rd-party/builds" "$_m/build/bin"
printf '#!/bin/sh\necho "clang version 20 (Fil-C 0.685 https://x/y.git abc)"\n' > "$_m/build/bin/clang-20"; chmod +x "$_m/build/bin/clang-20"
printf 'echo "packing $PACKAGE_CLANG"; mkdir -p filc-0.685-linux-%s; printf x | xz > filc-0.685-linux-%s.xz\n' "$_host" "$_host" \
    > "$_m/3rd-party/builds/package-build.sh"
: > "$_sb/musl-started"; sleep 1
_log=$( ( filc_upload_archive() { echo "publish@$1"; }; BUILD_DIR=$_m; ARCH=$_host; CROSS=""; PUBLISH=1
          filc_upstream_package "$_sb/musl-started" ) 2>&1)
expect 'it packs with upstream'"'"'s package-build.sh, the arch'"'"'s own clang' "packing $_m/build/bin/clang-20" \
    "$(printf '%s\n' "$_log" | grep '^packing')"
expect 'the package lands in dist/ under the upstream name, and is published' \
    "filc-0.685-linux-$_host.xz publish@filc-0.685-linux-$_host.xz no" \
    "$(ls "$DIST") $(printf '%s\n' "$_log" | grep '^publish@') $([ -d "$_m/filc-0.685-linux-$_host" ] && echo yes || echo no)"
expect 'its release text says it is usable wherever it is unpacked' \
    "Linux $_host, musl, usable wherever it is unpacked (./setup.sh)" \
    "$( (filc_archived_clang() { :; }; filc_asset_description "filc-0.685-linux-$_host.xz") )"
DIST=$_sb/dist-unused
LIBC=glibc   # the default again, for the specs below

test_section 'filc_warning / filc_optfil_root / filc_optfil_install -- /opt/fil as upstream'

expect "filc_warning lays out a warning the way build-handler.sh does" \
    "$(printf '\nWARNING: first\n         second\n         third\n\n')" \
    "$(filc_warning first second third 2>&1 >/dev/null)"
expect 'with no lines it prints nothing' '' "$(filc_warning 2>&1)"
_root_run() {   # $1 = what sudo does: ok or fail; then the flags
    local how="$1"; shift
    (
        sudo() { [ "$how" = ok ]; }
        filc_parse_args "$@"; HOST_BUILD_DIR=$_sb/ws; ROOT=$_sb/tree
        filc_optfil_root
        [ -z "${FILC_SUDO_KEEPALIVE:-}" ] || kill "$FILC_SUDO_KEEPALIVE" 2>/dev/null
        echo "install=$INSTALL"
    ) 2>&1
}
expect '--headless with no root warns, and leaves /opt/fil alone' \
    "WARNING: No root password at hand (--headless), so /opt/fil is left alone:|install=0" \
    "$(_root_run fail --headless | grep -E '^WARNING|^install=' | tr '\n' '|' | sed 's/|$//')"
expect 'it names where the toolchain stays instead' 1 \
    "$(_root_run fail --headless | grep -c "stays in $_sb/ws (and this tree, $_sb/tree)")"
expect '--headless with root installs' 'install=1' "$(_root_run ok --headless | tail -1)"
expect 'without --headless it asks for the password, and installs' 'install=1' "$(_root_run ok | tail -1)"
_root_run_status() { ( sudo() { false; }; filc_parse_args; filc_optfil_root ) > /dev/null 2>&1; }
expect_returns 'a refused password stops the run' 1 _root_run_status

# filc_optfil_install with sudo running its command as is, and optfil/'s scripts faked:
# build_opt.sh notes it ran, build_package.sh leaves the package build_finish.sh makes.
_opt=$_sb/opt-ws; DIST=$_sb/opt-dist; rm -rf "$_opt" "$DIST"
mkdir -p "$_opt/optfil" "$_opt/build/bin"
printf '#!/bin/sh\necho "clang version 20 (Fil-C 0.685 https://x/y.git abc)"\n' > "$_opt/build/bin/clang-20"
printf '#!/bin/sh\necho build_opt\n' > "$_opt/optfil/build_opt.sh"
printf '#!/bin/sh\necho build_package; printf x | xz > optfil-0.685-linux-%s.xz\n' "$_host" > "$_opt/optfil/build_package.sh"
chmod +x "$_opt/build/bin/clang-20" "$_opt/optfil/"*.sh
_opt_run() {
    ( sudo() { case "$1" in mkdir) echo "sudo mkdir $*" ;; *) "$@" ;; esac; }
      filc_upload_archive() { echo "publish@$1"; }
      BUILD_DIR=$_opt; ARCH=$_host; CROSS=""; NOXZ="${_NOXZ:-}"; PUBLISH="${_PUB:-0}"
      : > "$_sb/opt-started"; sleep 1
      filc_optfil_install "$_sb/opt-started" ) 2>&1
}
_log=$(_opt_run)
expect 'it runs upstream build_opt.sh, then build_package.sh, as root' 'build_opt build_package' \
    "$(printf '%s\n' "$_log" | grep -E '^build_(opt|package)$' | tr '\n' ' ' | sed 's/ $//')"
expect 'the package lands in dist/ under the upstream name' "optfil-0.685-linux-$_host.xz" \
    "$(ls "$DIST")"
expect 'it publishes only with --publish' "0 publish@optfil-0.685-linux-$_host.xz" \
    "$(printf '%s\n' "$_log" | grep -c '^publish@') $(_PUB=1 _opt_run | grep '^publish@')"
expect '--no-xz installs without packing' 'build_opt' \
    "$(_NOXZ=1 _opt_run | grep -E '^build_(opt|package)$' | tr '\n' ' ' | sed 's/ $//')"
expect 'its release text says where it goes' \
    "Linux $_host, glibc, installed at /opt/fil (sudo ./setup.sh --unattended); its clang runs on its own glibc" \
    "$(filc_asset_description "optfil-0.685-linux-$_host.xz")"
DIST=$_sb/dist-unused

test_section 'filc_main -- each arch of --archs'

# As _steps_run, for the archs: each stubbed step says its name and arch; packing says
# the tag and the build folder (or the export's tree) too.
_xsteps() {
    (
        filc_install_bison() { :; }
        filc_mirror() {
            mkdir -p "$BUILD_DIR/pizfix/lib"; rm -f "$BUILD_DIR"/pizfix/lib/*
            # shellcheck disable=SC2086
            ( cd "$BUILD_DIR/pizfix/lib" && touch libpizlo.so libc.so.6666 libc++.so )
        }
        filc_install_cross() { echo "cross@$1"; }
        filc_cross_helper() { echo "helper@$ARCH"; }
        filc_build_clang() { echo "clang@$ARCH"; }
        filc_build_runtime_libc() { echo "runtime@$ARCH"; }
        filc_runtime_env() { :; }
        filc_build_cxx() { echo "cxx@$ARCH"; }
        filc_cxx_built() { :; }
        filc_optfil_root() { echo "root@sudo"; }
        filc_optfil_install() { echo "optfil@$ARCH"; }
        filc_optfil_package() { echo "optfilpkg@$ARCH"; }
        filc_upstream_package() { echo "muslpkg@$ARCH"; }
        filc_sync_all() { echo "sync@$ARCH"; }
        filc_upload_archive() { echo "publish@$1"; }
        filc_clean_all() { echo "clean@$(basename "$BUILD_DIR")"; }
        filc_download_toolchain() { return 1; }
        ROOT=$_sb/xs-tree; BUILD_DIR=$_sb/xs-ws; DIST=$_sb/xs-dist; TOOLS=$_sb/xs-tools
        filc_main --no-install "$@"
    ) 2>&1 | grep -o '[a-z]*@[^ ]*\|^export: .*' | tr '\n' ' ' | sed 's/ $//'
}
rm -rf "$_sb/xs-dist"
expect 'all archs: the host first, synced; then the foreign one, cross-compiled, not synced; each packed for /opt/fil' \
    "clang@$_host runtime@$_host sync@$_host optfilpkg@$_host cross@$_other helper@$_other clang@$_other runtime@$_other optfilpkg@$_other" \
    "$(_xsteps --archs=all --nightly --publish)"
expect 'a foreign arch alone, with no prebuilt toolchain, builds only it from source' \
    "cross@$_other helper@$_other clang@$_other runtime@$_other" \
    "$(_xsteps "--archs=$_other")"
expect 'a universal build packs each arch for /opt/fil, through its runtime portions' \
    "clang@$_host runtime@$_host sync@$_host optfilpkg@$_host cross@$_other helper@$_other clang@$_other runtime@$_other optfilpkg@$_other" \
    "$(_xsteps --nightly --universal --archs=all --no-publish)"
expect '--clean cleans the build folder of each arch' "clean@xs-ws clean@xs-ws-$_other" \
    "$(_xsteps --clean --archs=all)"
expect '--prerequisites fetches the cross root of each foreign arch' "cross@$_other" \
    "$(_xsteps --prerequisites --archs=all)"
expect '--install asks for root first, installs this arch at /opt/fil, only packs the foreign one' \
    "root@sudo clang@$_host runtime@$_host sync@$_host optfil@$_host cross@$_other helper@$_other clang@$_other runtime@$_other optfilpkg@$_other" \
    "$(_xsteps --nightly --install --archs=all)"
expect 'a foreign arch alone asks for no root, and is only packed' \
    "cross@$_other helper@$_other clang@$_other runtime@$_other optfilpkg@$_other" \
    "$(_xsteps --nightly --install "--archs=$_other")"
expect '--no-install packs this arch for /opt/fil too, with no root' \
    "clang@$_host runtime@$_host sync@$_host optfilpkg@$_host" \
    "$(_xsteps --nightly --install --no-install)"
expect '--musl asks for no root, installs nothing, and packs each arch upstream'"'"'s musl way' \
    "clang@$_host runtime@$_host sync@$_host muslpkg@$_host cross@$_other helper@$_other clang@$_other runtime@$_other muslpkg@$_other" \
    "$(_xsteps --musl --nightly --archs=all)"
rm -rf "$_sb/xs-dist"; mkdir -p "$_sb/xs-dist"
for _f in "optfil-0.685-linux-$_host" "filc-0.685-linux-$_host" "optfil-0.685-linux-$_other" \
          "filc-linux-universal-$_host"; do printf x | xz > "$_sb/xs-dist/$_f.xz"; done
expect '--no-build --publish publishes the upstream-named packages of each arch' \
    "publish@optfil-0.685-linux-$_host.xz publish@filc-0.685-linux-$_host.xz publish@optfil-0.685-linux-$_other.xz" \
    "$(_xsteps --archs=all --no-build --publish)"
expect 'only of the archs asked for, never an old-named archive' \
    "publish@optfil-0.685-linux-$_host.xz publish@filc-0.685-linux-$_host.xz" \
    "$(_xsteps --no-build --publish)"
expect 'a foreign export needs a toolchain built in its build folder' \
    "export: no $_other toolchain built in $_sb/xs-ws-$_other to pack" \
    "$(_xsteps --export "--archs=$_other")"
if [ -x "$_sb/cxx" ]; then
    mkdir -p "$_sb/xs-ws-$_other/clang-build/bin"
    cp "$_sb/cxx" "$_sb/xs-ws-$_other/clang-build/bin/clang-20"
    expect 'which it packs the way upstream packs one' "muslpkg@$_other" \
        "$(_xsteps --export "--archs=$_other")"
else
    test_skip 'which it packs the way upstream packs one' 'no host C++ compiler for a test clang'
fi


test_section 'filc_build_clang -- --rebuild=clang starts from scratch'

# filc_build_clang with cmake, ninja and patchelf stubbed: "building" writes a clang that
# needs the shared libstdc++ (the host-only linkage), so a plain run finds it already built.
# cmake logs its arguments to cmake.args and caches the LLVM targets they name.
_cmake_stub() {
    printf '%s\n' "$@" "LD_LIBRARY_PATH=${LD_LIBRARY_PATH:-}" > "$_sb/cmake.args"
    printf 'LLVM_TARGETS_TO_BUILD:STRING=%s\n' \
        "$(printf '%s\n' "$@" | sed -n 's/^-DLLVM_TARGETS_TO_BUILD=//p')" > CMakeCache.txt
}
_clang_run() {   # $@ = filc_parse_args flags
    (
        cmake() { _cmake_stub "$@"; }
        ninja() { mkdir -p bin; cp "$_sb/cxx-or-true" "bin/clang-$CLANGVER"; }
        patchelf() { :; }
        ROOT=$_sb/clang-tree; BUILD_DIR=$_sb/clang-ws
        filc_parse_args "$@" -d "$BUILD_DIR"
        BUILT=""; SYNCED=""
        filc_build_clang "$STATIC" > "$_sb/clang-run.log" 2>&1
    )
}
if [ -x "$_sb/cxx" ]; then cp "$_sb/cxx" "$_sb/cxx-or-true"; else cp "$(command -v true)" "$_sb/cxx-or-true"; fi
mkdir -p "$_sb/clang-tree/compiler/llvm" "$_sb/clang-ws/libpas" "$_sb/clang-ws/build/bin"
: > "$_sb/clang-tree/compiler/llvm/CMakeLists.txt"
cp "$_root/libpas/common.sh" "$_sb/clang-ws/libpas/common.sh"   # it sets ARCH, to the host's
cp "$_sb/cxx-or-true" "$_sb/clang-ws/build/bin/clang-20"
printf 'LLVM_TARGETS_TO_BUILD:STRING=%s\n' "$(filc_llvm_target "$(filc_host_arch)")" \
    > "$_sb/clang-ws/build/CMakeCache.txt"
: > "$_sb/clang-ws/build/old.o"
if [ -x "$_sb/cxx" ]; then
    _clang_run --nightly
    expect 'a plain build reuses a clang already built' '1 kept' \
        "$(grep -c 'clang already built' "$_sb/clang-run.log") $([ -e "$_sb/clang-ws/build/old.o" ] && echo kept || echo gone)"
else
    test_skip 'a plain build reuses a clang already built' 'no host C++ compiler for a test clang'
fi
_clang_run --rebuild=clang
expect '--rebuild=clang removes the earlier LLVM build first' '1 gone' \
    "$(grep -c 'clean: removed the clang build output' "$_sb/clang-run.log") $([ -e "$_sb/clang-ws/build/old.o" ] && echo kept || echo gone)"
expect 'and then builds clang again' yes "$([ -x "$_sb/clang-ws/build/bin/clang-20" ] && echo yes)"
: > "$_sb/clang-ws/build/old.o"
_clang_run --rebuild=pas
expect '--rebuild of another portion keeps the LLVM build' kept \
    "$([ -e "$_sb/clang-ws/build/old.o" ] && echo kept || echo gone)"
_clang_run --rebuild
expect 'bare --rebuild removes the earlier LLVM build too' '1 gone' \
    "$(grep -c 'clean: removed the clang build output' "$_sb/clang-run.log") $([ -e "$_sb/clang-ws/build/old.o" ] && echo kept || echo gone)"


test_section 'filc_build_clang -- the LLVM targets, and a foreign arch'

# filc_build_clang of <arch> with the <linkage> asked for, and ARCHS=all, its tools
# stubbed as above; prints what it synced.
_xclang_run() {   # $1 = arch, $2 = linkage
    (
        cmake() { _cmake_stub "$@"; }
        ninja() { mkdir -p bin; cp "$_sb/cxx-or-true" "bin/clang-$CLANGVER"; }
        patchelf() { :; }
        ROOT=$_sb/clang-tree; HOST_BUILD_DIR=$_sb/clang-ws; TOOLS=$_sb/clang-tools
        ARCHS=$(filc_parse_archs all); FILC_CLEAN_FILTER=${_CLEAN:-}; FILC_SYNC_FILTER='^.*$'
        filc_use_arch "$1"
        mkdir -p "$BUILD_DIR/libpas"
        cp "$_sb/clang-ws/libpas/common.sh" "$BUILD_DIR/libpas/"
        BUILT=""; SYNCED=""
        filc_build_clang "$2" > "$_sb/clang-run.log" 2>&1
        echo "$SYNCED"
    )
}
_arg() { grep -c -x -- "$1" "$_sb/cmake.args"; }
_clang_run --nightly
_xclang_run "$_host" dynamic > /dev/null
expect 'a host clang lacking the target of an arch asked for is reconfigured with it' '1 1' \
    "$(grep -c 'lacks an LLVM target' "$_sb/clang-run.log") $(_arg '-DLLVM_TARGETS_TO_BUILD=X86;AArch64')"
if [ -x "$_sb/cxx" ]; then
    _xclang_run "$_host" dynamic > /dev/null
    expect 'once it has them it is reused' 1 "$(grep -c 'clang already built' "$_sb/clang-run.log")"
    _xclang_run "$_host" any > /dev/null
    expect 'any linkage reuses a dynamic clang' 1 "$(grep -c 'clang already built' "$_sb/clang-run.log")"
    cp "$_sb/c" "$_sb/clang-ws/build/bin/clang-20"
    _xclang_run "$_host" any > /dev/null
    expect 'and a universal one, without re-linking it' 1 "$(grep -c 'clang already built' "$_sb/clang-run.log")"
    cp "$_sb/c" "$_sb/clang-ws/build/bin/clang-20"
    _xclang_run "$_host" dynamic > /dev/null
    expect 'while dynamic re-links a universal one' 1 "$(grep -c 're-linking it' "$_sb/clang-run.log")"
else
    test_skip 'reusing a clang by its linkage' 'no host C++ compiler for a test clang'
fi
_synced=$(_xclang_run "$_other" dynamic)
expect 'a foreign clang is cross-compiled for its arch alone' '1 1 1 1' \
    "$(_arg "-DCMAKE_SYSTEM_PROCESSOR=$_other") $(_arg "-DLLVM_HOST_TRIPLE=$_other-linux-gnu") $(_arg "-DCMAKE_CXX_COMPILER_TARGET=$_other-linux-gnu") $(_arg "-DLLVM_TARGETS_TO_BUILD=$(filc_llvm_target "$_other")")"
expect 'against its cross root, with the host tablegens' '1 1' \
    "$(_arg "-DCMAKE_SYSROOT=$_sb/clang-tools/cross-$_other") $(_arg "-DLLVM_NATIVE_TOOL_DIR=$_sb/clang-ws/build/bin")"
expect "with the cross binutils' libraries found, for cmake's compiler checks" 1 \
    "$(grep -c "^LD_LIBRARY_PATH=$_sb/clang-tools/cross-$_other/usr/lib/" "$_sb/cmake.args")"
expect 'into clang-build/ of its build folder' yes \
    "$([ -x "$_sb/clang-ws-$_other/clang-build/bin/clang-20" ] && echo yes)"
expect 'and it is never synced into the tree' '' "$_synced"
if [ -x "$_sb/cxx" ]; then
    _xclang_run "$_other" dynamic > /dev/null
    expect 'a built foreign clang is reused, without running it' 1 \
        "$(grep -c "clang for $_other already built" "$_sb/clang-run.log")"
fi
mkdir -p "$_sb/clang-ws-$_other/build/bin"; : > "$_sb/clang-ws-$_other/build/bin/clang-20"
: > "$_sb/clang-ws-$_other/clang-build/old.o"
_CLEAN='^clang$' _xclang_run "$_other" dynamic > /dev/null
expect "--rebuild=clang of a foreign arch drops its clang-build/, not the host clang in build/" \
    'gone kept' \
    "$([ -e "$_sb/clang-ws-$_other/clang-build/old.o" ] && echo kept || echo gone) $([ -e "$_sb/clang-ws-$_other/build/bin/clang-20" ] && echo kept || echo gone)"


# ---- specs: cross-compiling a foreign arch ------------------------------------

test_section 'filc_install_cross -- the cross root, fetched rootless'

# apt-get and dpkg-deb stubbed: they log what they are asked for to xi.log.
_xi_run() {   # $1 = arch
    (
        TOOLS=$_sb/xi-tools
        apt-get() { shift; echo "apt-get $*" >> "$_sb/xi.log"; for _p in "$@"; do : > "${_p}_1_all.deb"; done; }
        dpkg-deb() { echo "dpkg-deb $(basename "$2")" >> "$_sb/xi.log"; mkdir -p "$3/usr/bin"; }
        filc_install_cross "$1"
    )
}
_v=$(gcc -dumpversion 2>/dev/null | cut -d. -f1)
rm -rf "$_sb/xi-tools" "$_sb/xi.log"
_xi_run aarch64 > /dev/null
expect 'aarch64 takes the arm64 -cross packages and the aarch64-linux-gnu GCC of the host GCC version' \
    "apt-get libc6-dev-arm64-cross libc6-arm64-cross linux-libc-dev-arm64-cross libgcc-$_v-dev-arm64-cross libgcc-s1-arm64-cross libstdc++-$_v-dev-arm64-cross libstdc++6-arm64-cross gcc-$_v-aarch64-linux-gnu cpp-$_v-aarch64-linux-gnu gcc-$_v-aarch64-linux-gnu-base binutils-aarch64-linux-gnu" \
    "$(grep '^apt-get' "$_sb/xi.log")"
expect 'each package is unpacked into the cross root' 11 "$(grep -c '^dpkg-deb' "$_sb/xi.log")"
expect 'the downloads are not kept' gone \
    "$([ -d "$_sb/xi-tools/cross-aarch64/deb" ] && echo kept || echo gone)"
: > "$_sb/xi.log"
expect 'a complete cross root is not fetched again' '1 0' \
    "$(_xi_run aarch64 | grep -c 'already present') $(grep -c . "$_sb/xi.log")"
_xi_run x86_64 > /dev/null
expect 'x86_64 takes amd64 packages, and x86-64 in the GCC package names' \
    "libc6-dev-amd64-cross gcc-$_v-x86-64-linux-gnu binutils-x86-64-linux-gnu" \
    "$(grep '^apt-get' "$_sb/xi.log" | tr ' ' '\n' | grep -Ex 'libc6-dev-.*|gcc-[0-9]+-x86-64-linux-gnu|binutils-.*' | tr '\n' ' ' | sed 's/ $//')"

test_section 'filc_cross_helper -- the host clang, aimed at a foreign arch'

(
    ROOT=$_sb/xh-tree; HOST_BUILD_DIR=$_sb/xh-ws; TOOLS=$_sb/xh-tools
    filc_mirror() { :; }
    filc_build_clang() { echo "$1 $BUILD_DIR ${CROSS:-native} ${FILC_CLEAN_FILTER:-none}" > "$_sb/xh.log"; }
    mkdir -p "$HOST_BUILD_DIR/build/bin" "$HOST_BUILD_DIR/build/lib/clang/20"
    echo host-clang > "$HOST_BUILD_DIR/build/bin/clang-20"
    FILC_CLEAN_FILTER='^.*$'
    filc_use_arch "$_other"
    filc_cross_helper
)
expect "the host build folder's clang is built first, in any linkage, cleaning nothing" \
    "any $_sb/xh-ws native none" "$(cat "$_sb/xh.log")"
expect 'it is hard-linked into the foreign build folder' same \
    "$([ "$_sb/xh-ws/build/bin/clang-20" -ef "$_sb/xh-ws-$_other/build/bin/clang-20" ] && echo same)"
expect 'clang.cfg and clang++.cfg aim it at the arch' "--target=$_other-linux-gnu --target=$_other-linux-gnu" \
    "$(cat "$_sb/xh-ws-$_other/build/bin/clang.cfg" "$_sb/xh-ws-$_other/build/bin/clang++.cfg" | tr '\n' ' ' | sed 's/ $//')"
expect 'clang and clang++ run it' 'clang-20 clang-20' \
    "$(readlink "$_sb/xh-ws-$_other/build/bin/clang") $(readlink "$_sb/xh-ws-$_other/build/bin/clang++")"
expect "its resource dir is the host clang's" "$_sb/xh-ws/build/lib/clang" \
    "$(readlink "$_sb/xh-ws-$_other/build/lib/clang")"

test_section 'filc_cross_tools / filc_cross_env -- upstream scripts build for the arch'

HOST_BUILD_DIR=$_sb/xt-ws; TOOLS=$_sb/xt-tools
filc_use_arch "$_other"
rm -rf "$XROOT" "$BUILD_DIR"; mkdir -p "$XROOT/usr/bin" "$BUILD_DIR"
# A fake cross root: each tool says its name, its arguments and its LD_LIBRARY_PATH.
for _t in gcc-15 cpp-15 ld strip; do
    printf '#!/bin/sh\necho "%s $* LD=$LD_LIBRARY_PATH"\n' "$_t" > "$XROOT/usr/bin/$CROSS-$_t"
done
chmod +x "$XROOT"/usr/bin/*
filc_cross_tools
_in_env() { ( cd "$BUILD_DIR" && filc_cross_env && eval "$1" ); }
expect 'uname -m names the arch' "$_other" "$(_in_env 'uname -m')"
expect 'uname -s still names the system' "$(uname -s)" "$(_in_env 'uname -s')"
expect 'arch names the arch' "$_other" "$(_in_env arch)"
expect 'gcc is the cross GCC on the cross root, finding its binutils libraries' \
    "gcc-15 --sysroot=$XROOT -v LD=$(filc_cross_libdir)" "$(_in_env 'gcc -v' | sed 's/:.*//')"
expect 'cc too' "gcc-15 --sysroot=$XROOT -c" "$(_in_env 'cc -c' | sed 's/ LD=.*//')"
expect 'cpp is the cross preprocessor' "cpp-15 --sysroot=$XROOT -E" "$(_in_env 'cpp -E' | sed 's/ LD=.*//')"
expect 'ld is the cross linker' "ld -v LD=$(filc_cross_libdir)" "$(_in_env 'ld -v' | sed 's/:.*//')"
expect "glibc's configure is told it cross-compiles" cross_compiling=yes "$(_in_env 'cat "$CONFIG_SITE"')"
expect "glibc's helper programs build with the host GCC" "$(command -v gcc)" "$(_in_env 'echo "$BUILD_CC"')"
expect 'libpas compiles with the clang on PATH' clang "$(_in_env 'echo "$HOST_CLANG"')"
expect 'the cross binutils find their libraries when run by path too' "$(filc_cross_libdir)" \
    "$(_in_env 'echo "${LD_LIBRARY_PATH%%:*}"')"
if clang "--target=$CROSS" -print-target-triple > /dev/null 2>&1; then
    expect 'clang is the host clang aimed at the arch' "$_other-unknown-linux-gnu" \
        "$(_in_env 'clang -print-target-triple')"
    expect 'c++ too, in C++ mode' "$_other-unknown-linux-gnu 1" \
        "$(_in_env 'c++ -print-target-triple') $(_in_env 'c++ -### -x c -c /dev/null 2>&1' | grep -c -- '"-x" "c++"\|"-cc1"')"
else
    test_skip 'clang is the host clang aimed at the arch' "the host clang cannot target $CROSS"
fi
expect 'a portion runs with them' "$_other" "$(filc_portion xtest sh -c 'uname -m' | tail -1)"
expect "and this script's own PATH stays as it was" no \
    "$(case ":$PATH:" in *.filc-cross*) echo yes ;; *) echo no ;; esac)"

# build_compiler_rt.sh stubbed: it says the compilers it is given.
printf 'echo "CC=$CC CXX=$CXX"\n' > "$BUILD_DIR/build_compiler_rt.sh"
_crt_cache() {   # $1 = the C compiler compiler-rt's build is configured with
    mkdir -p "$BUILD_DIR/compiler-rt/build"
    echo "CMAKE_C_COMPILER:FILEPATH=$1" > "$BUILD_DIR/compiler-rt/build/CMakeCache.txt"
}
expect "compiler-rt builds its C and C++ with the clang aimed at the arch" 'CC=clang CXX=clang++' \
    "$(cd "$BUILD_DIR" && filc_cross_compiler_rt)"
_crt_cache "$BUILD_DIR/.filc-cross/bin/cc"
( cd "$BUILD_DIR" && filc_cross_compiler_rt > /dev/null )
expect 'a compiler-rt build configured with the cross GCC is redone' no \
    "$([ -d "$BUILD_DIR/compiler-rt/build" ] && echo yes || echo no)"
_crt_cache "$BUILD_DIR/.filc-cross/bin/clang"
( cd "$BUILD_DIR" && filc_cross_compiler_rt > /dev/null )
expect 'one configured with that clang is kept' yes \
    "$([ -d "$BUILD_DIR/compiler-rt/build" ] && echo yes || echo no)"

test_section "filc_cross_os_include -- a foreign arch's kernel headers"

mkdir -p "$XROOT/usr/$CROSS/include/linux" "$XROOT/usr/$CROSS/include/asm" \
         "$XROOT/usr/$CROSS/include/asm-generic"
( cd "$BUILD_DIR" && filc_cross_os_include )
expect "while building, the kernel headers are the cross root's" "$XROOT/usr/$CROSS/include/asm" \
    "$(readlink "$BUILD_DIR/pizfix/os-include/asm")"

test_section 'filc_pizfix_sub / filc_relocate_runpaths / filc_set_interpreters -- no build paths'

expect 'a path below pizfix/ is told by its part there' '/lib' "$(filc_pizfix_sub /w/build/bin/../../pizfix/lib)"
expect 'also below a yolo/ inside it' '/yolo/lib/ld-linux.so.2' \
    "$(filc_pizfix_sub /w/x-build/../pizfix/yolo/lib/ld-linux.so.2)"
expect 'the pizfix/ folder itself is its root' '/' "$(filc_pizfix_sub /w/pizfix)"
expect 'a path elsewhere has none' '' "$(filc_pizfix_sub /usr/lib)"
expect 'an /opt/fil path (an optfil package) maps the same way' '/lib/ld-fil1-x86_64.so /' \
    "$(filc_pizfix_sub /opt/fil/lib/ld-fil1-x86_64.so) $(filc_pizfix_sub /opt/fil)"
if [ -n "$_cc" ] && command -v patchelf > /dev/null; then
    # A pizfix/ built somewhere else: its libraries and programs name that place.
    _pz=$_sb/moved/pizfix
    rm -rf "$_sb/moved"; mkdir -p "$_pz/lib/gconv" "$_pz/bin"
    echo 'int f(void) { return 1; }' > "$_sb/f.c"
    "$_cc" -shared -fPIC -o "$_pz/lib/libf.so" "$_sb/f.c" -Wl,-rpath,/w/build/bin/../../pizfix/lib
    "$_cc" -shared -fPIC -o "$_pz/lib/gconv/MOD.so" "$_sb/f.c" -Wl,-rpath,'/w/b/../pizfix/lib:$ORIGIN'
    "$_cc" -o "$_pz/bin/prog" "$_sb/c.c" -Wl,-rpath,/w/pizfix/lib:/usr/lib \
        -Wl,--dynamic-linker=/w/build/bin/../../pizfix/lib/ld-fil1-test.so
    cp "$_pz/lib/libf.so" "$_pz/lib/ld-fil1-test.so"
    echo 'not an ELF' > "$_pz/bin/script"
    filc_relocate_runpaths "$_pz" 2> "$_sb/rp.err"
    expect 'a library finds pizfix/lib from where it is' '$ORIGIN' "$(patchelf --print-rpath "$_pz/lib/libf.so")"
    expect 'an iconv module too, keeping its own $ORIGIN' '$ORIGIN/..:$ORIGIN' \
        "$(patchelf --print-rpath "$_pz/lib/gconv/MOD.so")"
    expect 'a program from bin/, keeping a folder outside pizfix/' '$ORIGIN/../lib:/usr/lib' \
        "$(patchelf --print-rpath "$_pz/bin/prog")"
    expect 'a file that is not ELF is left alone, quietly' 'not an ELF|' "$(cat "$_pz/bin/script")|$(cat "$_sb/rp.err")"
    filc_set_interpreters "$_pz"
    expect "a program's interpreter is this pizfix/'s loader" "$_pz/lib/ld-fil1-test.so" \
        "$(patchelf --print-interpreter "$_pz/bin/prog")"
else
    test_skip 'filc_relocate_runpaths / filc_set_interpreters' 'no C compiler or no patchelf'
fi

test_section 'filc_relocate_ld_scripts -- linker scripts that work wherever pizfix/ is'

_rl=$_sb/rl/pizfix/lib
mkdir -p "$_rl"
cat > "$_rl/libc.so" <<'LDS'
/* GNU ld script
   Use the shared library, but some functions are only in
   the static library, so try that secondarily.  */
OUTPUT_FORMAT(elf64-x86-64)
GROUP ( /w/pizlonated-user-glibc-build/../pizfix/lib/libc.so.6666 /w/pizlonated-user-glibc-build/../pizfix/lib/libc_nonshared.a  AS_NEEDED ( /w/pizfix/lib/ld-fil1-x86_64.so ) )
LDS
printf 'OUTPUT_FORMAT(elf64-x86-64)\nGROUP ( /opt/fil/lib/libyolocimpl.so /opt/fil/lib/libyoloc_nonshared.a  AS_NEEDED ( /opt/fil/lib/ld-fil1-x86_64.so ) )\n' > "$_rl/libyoloc.so"
printf '\177ELF/w/pizfix/lib/not-a-script' > "$_rl/libpizlo.so"
ln -s libc.so "$_rl/libalias.so"
filc_relocate_ld_scripts "$_sb/rl/pizfix"
expect 'the GROUP names its libraries bare, for ld to find in pizfix/lib' \
    'GROUP ( libc.so.6666 libc_nonshared.a  AS_NEEDED ( ld-fil1-x86_64.so ) )' "$(grep '^GROUP' "$_rl/libc.so")"
expect 'the comment and the output format stay' 'yes OUTPUT_FORMAT(elf64-x86-64)' \
    "$(head -1 "$_rl/libc.so" | grep -q 'GNU ld script' && echo yes) $(grep '^OUTPUT_FORMAT' "$_rl/libc.so")"
expect 'a script with no comment (fix_yolo_glibc.sh writes them) is relocated too' \
    'GROUP ( libyolocimpl.so libyoloc_nonshared.a  AS_NEEDED ( ld-fil1-x86_64.so ) )' "$(grep '^GROUP' "$_rl/libyoloc.so")"
expect 'a shared object is left alone' $'\177ELF/w/pizfix/lib/not-a-script' "$(cat "$_rl/libpizlo.so")"
expect 'as is a link' libc.so "$(readlink "$_rl/libalias.so")"

test_section "filc_build_cxx -- libc++ for the arch, as a standalone runtimes build"

# cmake records its arguments; ninja installs a fake libc++ the way the runtimes build lays
# it out (headers, the per-target __config_site, libraries under lib/<triple>).
_cxx_run() {
    (
        cmake() { printf '%s\n' "$@" > "$_sb/cxx-cmake.args"; }
        ninja() {
            local inst="$BUILD_DIR/cxx-install" t; t="$(filc_cxx_triple)"
            mkdir -p "$inst/include/c++/v1" "$inst/include/$t/c++/v1" "$inst/lib/$t"
            : > "$inst/include/c++/v1/vector"; : > "$inst/include/$t/c++/v1/__config_site"
            for _f in libc++.so libc++.so.1.0 libc++abi.so.1.0 libc++.a libc++abi.a libc++experimental.a; do
                echo "$t" > "$inst/lib/$t/$_f"
            done
            printf '%s\n' "$@" > "$_sb/cxx-ninja.args"
        }
        cd "$BUILD_DIR" && filc_build_cxx
    )
}
mkdir -p "$BUILD_DIR/libpas"
cp "$_root/libpas/common.sh" "$BUILD_DIR/libpas/"
_cxx_run
_t="$_other-unknown-linux-gnu"
expect 'a foreign arch is compiled by its own Fil-C clang (the helper)' \
    "-DCMAKE_C_COMPILER=$BUILD_DIR/build/bin/clang -DCMAKE_CXX_COMPILER=$BUILD_DIR/build/bin/clang++" \
    "$(grep -E '^-DCMAKE_(C|CXX)_COMPILER=' "$_sb/cxx-cmake.args" | tr '\n' ' ' | sed 's/ $//')"
expect 'cross-compiling for the arch, under its triple' "Linux $_other $_t $_t" \
    "$(for _k in CMAKE_SYSTEM_NAME CMAKE_SYSTEM_PROCESSOR CMAKE_C_COMPILER_TARGET LLVM_DEFAULT_TARGET_TRIPLE; do
         sed -n "s/^-D$_k=//p" "$_sb/cxx-cmake.args"; done | tr '\n' ' ' | sed 's/ $//')"
expect "from compiler/runtimes, libc++ and libc++abi with upstream's options" \
    "$BUILD_DIR/compiler/runtimes|libcxx;libcxxabi|ON|ON|OFF" \
    "$(sed -n 2p "$_sb/cxx-cmake.args")|$(sed -n 's/^-DLLVM_ENABLE_RUNTIMES=//p' "$_sb/cxx-cmake.args")|$(sed -n 's/^-DLIBCXX_ENABLE_EXCEPTIONS=//p' "$_sb/cxx-cmake.args")|$(sed -n 's/^-DLIBCXXABI_HAS_PTHREAD_API=//p' "$_sb/cxx-cmake.args")|$(sed -n 's/^-DLIBCXXABI_USE_LLVM_UNWINDER=//p' "$_sb/cxx-cmake.args")"
expect 'the compiler checks are skipped: clang++ links the libc++ not built yet' 'ON ON' \
    "$(sed -n 's/^-DCMAKE_C_COMPILER_WORKS=//p; s/^-DCMAKE_CXX_COMPILER_WORKS=//p' "$_sb/cxx-cmake.args" | tr '\n' ' ' | sed 's/ $//')"
expect 'ninja installs only libc++ and libc++abi' 'install-cxx install-cxxabi' \
    "$(tail -2 "$_sb/cxx-ninja.args" | tr '\n' ' ' | sed 's/ $//')"
expect 'the libraries land in pizfix/lib, the arch'"'"'s ones' "$_t $_t" \
    "$(cat "$BUILD_DIR/pizfix/lib/libc++.so.1.0" "$BUILD_DIR/pizfix/lib/libc++abi.a" | tr '\n' ' ' | sed 's/ $//')"
expect 'with the soname links of install-cxx-linux.sh' 'libc++.so.1.0 libc++abi.so.1.0 libc++abi.so.1' \
    "$(cd "$BUILD_DIR/pizfix/lib" && readlink libc++.so.1 libc++abi.so.1 libc++abi.so | tr '\n' ' ' | sed 's/ $//')"
expect 'the headers land beside the clang that compiles with them' yes \
    "$([ -e "$BUILD_DIR/build/include/c++/v1/vector" ] && [ -e "$BUILD_DIR/build/include/$_t/c++/v1/__config_site" ] && echo yes)"
expect_returns 'so libc++ counts as built' 0 filc_cxx_built
rm "$BUILD_DIR/build/include/c++/v1/vector"
expect_returns 'libc++ without its headers is not built' 1 filc_cxx_built
filc_use_arch "$_host"
mkdir -p "$BUILD_DIR/libpas"
cp "$_root/libpas/common.sh" "$BUILD_DIR/libpas/"
_cxx_run
expect 'the host arch builds natively, under its own triple' "|$_host-unknown-linux-gnu" \
    "$(sed -n 's/^-DCMAKE_SYSTEM_PROCESSOR=//p' "$_sb/cxx-cmake.args")|$(sed -n 's/^-DLLVM_DEFAULT_TARGET_TRIPLE=//p' "$_sb/cxx-cmake.args")"


test_section 'filc_main --clean -- only cleans'

BUILD_DIR=$_sb/clean-ws
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/build/bin" "$BUILD_DIR/compiler-rt/build" "$BUILD_DIR/pizfix/lib"
: > "$BUILD_DIR/build/bin/clang-20"; : > "$BUILD_DIR/pizfix/lib/libpizlo.so"
expect 'a clean-only run builds nothing' '' \
    "$(filc_build_clang() { echo clang; }; filc_build_runtime_libc() { echo runtime; }
       ( filc_main --clean=crt -d "$BUILD_DIR" ) 2>/dev/null | grep -E '^(clang|runtime)$')"
expect 'it cleans only the matching portions' 'gone kept' \
    "$([ -e "$BUILD_DIR/compiler-rt/build" ] && echo kept || echo gone) $([ -e "$BUILD_DIR/build" ] && echo kept || echo gone)"
expect 'and leaves the installed pizfix/ alone' yes "$([ -f "$BUILD_DIR/pizfix/lib/libpizlo.so" ] && echo yes)"
mkdir -p "$BUILD_DIR/build/bin" "$BUILD_DIR/compiler-rt/build" "$BUILD_DIR/yolounwind" \
         "$BUILD_DIR/pizlonated-yolo-glibc-build" "$BUILD_DIR/libpas/build" \
         "$BUILD_DIR/pizlonated-user-glibc-build"
: > "$BUILD_DIR/yolounwind/yolounwind.o"
( filc_main --clean -d "$BUILD_DIR" ) > /dev/null 2>&1
expect 'a bare --clean cleans every portion' '' \
    "$(ls -d "$BUILD_DIR/build" "$BUILD_DIR/compiler-rt/build" "$BUILD_DIR/yolounwind/yolounwind.o" \
             "$BUILD_DIR/pizlonated-yolo-glibc-build" "$BUILD_DIR/libpas/build" \
             "$BUILD_DIR/pizlonated-user-glibc-build" 2>/dev/null)"
expect 'and still leaves pizfix/ alone' yes "$([ -f "$BUILD_DIR/pizfix/lib/libpizlo.so" ] && echo yes)"
expect 'with no build folder there is nothing to clean' 1 \
    "$( ( filc_main --clean -d "$_sb/no-such-ws" ) 2>&1 | grep -c 'nothing to clean')"


# ---- specs: exporting ----------------------------------------------------------

test_section 'filc_optfil_set_version -- upstream'"'"'s optfil scripts get the tags'"'"' version'

_ov=$_sb/ov; rm -rf "$_ov"; mkdir -p "$_ov/optfil"
printf 'package_name=optfil-0.680-$OS-$ARCH\n' > "$_ov/optfil/build_finish.sh"
printf 'VERSION="0.680"\nARCH=x86_64\n' > "$_ov/optfil/setup.sh"
: > "$_ov/optfil/build_opt.sh"
( BUILD_DIR=$_ov; filc_optfil_set_version )
expect 'the package name and setup.sh'"'"'s VERSION say the upstream version' \
    'package_name=optfil-0.685-$OS-$ARCH|VERSION="0.685"' \
    "$(cat "$_ov/optfil/build_finish.sh")|$(head -1 "$_ov/optfil/setup.sh")"
rm -rf "$_ov/optfil"
_log=$( ( BUILD_DIR=$_ov; filc_optfil_set_version ) 2>&1; echo "exit@$?")
expect 'without optfil/ (git-ignored) it stops and says so' 'yes exit@1' \
    "$(grep -c 'optfil/ (upstream'"'"'s /opt/fil scripts' <<< "$_log" | sed 's/^1$/yes/') ${_log##*$'\n'}"

test_section 'filc_main --export -- the toolchain in use, packed as upstream packs it'

_tl=$_sb/tl; rm -rf "$_tl"; mkdir -p "$_tl/pizfix/lib"
expect 'a toolchain without a glibc is a musl one' musl "$(filc_toolchain_libc "$_tl")"
: > "$_tl/pizfix/lib/libc.so.6666"
expect 'one with libc.so.6666 a glibc one' glibc "$(filc_toolchain_libc "$_tl")"

ROOT=$_sb/exp-tree; BUILD_DIR=$_sb/exp-ws; DIST=$ROOT/dist; TOOLS=$_sb/exp-tools
mkdir -p "$ROOT/build/bin" "$ROOT/build/lib/clang/20/include" "$ROOT/pizfix/lib" "$ROOT/3rd-party/builds"
printf '#!/bin/sh\necho clang\n' > "$ROOT/build/bin/clang-20"
chmod +x "$ROOT/build/bin/clang-20"
: > "$ROOT/pizfix/lib/libpizlo.so"
# upstream's package-build.sh, faked: it says how it was run and packs build/ as upstream
# names a musl package.
cat > "$ROOT/3rd-party/builds/package-build.sh" <<'PKG'
echo "packed in ${PWD##*/}: version $PACKAGE_VERSION, clang ${PACKAGE_CLANG:-build/bin/clang-20}"
n=filc-$PACKAGE_VERSION-linux-$(uname -m)
mkdir -p "$n" && cp -R build "$n/" && tar -cJf "$n.xz" "$n"
PKG
expect 'without a build folder clang, the tree describes the archives' \
    "$ROOT/build/bin/clang-20" "$(filc_built_clang)"
curl() { echo called >> "$_sb/exp-curl.log"; }
( filc_main --export ) > "$_sb/exp.log" 2>&1
expect 'package-build.sh packs the tree'"'"'s own toolchain, at the upstream version' \
    'packed in exp-tree: version 0.685, clang build/bin/clang-20' "$(grep '^packed in' "$_sb/exp.log")"
expect 'the package lands in dist/ under its upstream name' "filc-0.685-linux-$(uname -m).xz" "$(ls "$DIST")"
expect 'it carries the Fil-C-Light marker, as a musl toolchain' \
    '[Version]|light=1.0.0|upstream=0.685|libc=musl' \
    "$(tar -xOJf "$DIST"/*.xz --wildcards '*/build/share/fil-c-light.ini' | tr '\n' '|' | sed 's/|$//')"
expect 'its unpacked folder is not left in the tree' '' "$(ls -d "$ROOT"/filc-* 2>/dev/null)"
expect 'it publishes nothing' '' "$(cat "$_sb/exp-curl.log" 2>/dev/null)"
expect 'it builds nothing' '' "$(ls -d "$BUILD_DIR" 2>/dev/null)"
rm -rf "$ROOT/build"
expect_returns 'without a toolchain to pack it fails' 1 filc_main --export
unset -f curl
mkdir -p "$BUILD_DIR/build/bin"
printf '#!/bin/sh\n' > "$BUILD_DIR/build/bin/clang-20"; chmod +x "$BUILD_DIR/build/bin/clang-20"
expect "a build folder clang wins over the tree's" "$BUILD_DIR/build/bin/clang-20" "$(filc_built_clang)"


# ---- specs: upstream scripts the archs change -------------------------------------

test_section 'fix_yolo_glibc.sh -- the yolo glibc of each arch'

# Runs fix_yolo_glibc.sh on an empty yolo glibc install of <arch> (a foreign one under
# filc_cross_env's uname), patchelf stubbed; prints the libc linker script's format and
# the loader (glibc names it ld-fil1-<arch>.so itself).
_fyg() {   # $1 = arch
    (
        HOST_BUILD_DIR=$_sb/fyg; TOOLS=$_sb/fyg-tools
        filc_use_arch "$1"
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR/libpas" "$BUILD_DIR/pizlonated-yolo-glibc-build" "$BUILD_DIR/stub" \
                 "$BUILD_DIR/pizfix/yolo/lib" "$BUILD_DIR/pizfix/yolo/include"
        cp "$_root/libpas/common.sh" "$BUILD_DIR/libpas/"
        for _f in "ld-fil1-$1.so" libc.so.6 libc_nonshared.a libm.so.6 libc.a libm.a crt1.o; do
            : > "$BUILD_DIR/pizfix/yolo/lib/$_f"
        done
        printf '#!/bin/sh\n' > "$BUILD_DIR/stub/patchelf"; chmod +x "$BUILD_DIR/stub/patchelf"
        if [ -n "$CROSS" ]; then mkdir -p "$XROOT/usr/bin"; filc_cross_tools; filc_cross_env; fi
        PATH="$BUILD_DIR/stub:$PATH"
        cd "$BUILD_DIR/pizlonated-yolo-glibc-build" && bash "$_root/fix_yolo_glibc.sh" > /dev/null 2>&1
        printf '%s %s' "$(head -1 "$BUILD_DIR/pizfix/lib/libyoloc.so" 2>/dev/null)" \
            "$(ls "$BUILD_DIR/pizfix/lib" 2>/dev/null | grep '^ld-fil1')"
    )
}
expect 'x86_64: the x86-64 loader and output format' 'OUTPUT_FORMAT(elf64-x86-64) ld-fil1-x86_64.so' \
    "$(_fyg x86_64)"
expect 'aarch64: the aarch64 loader and output format' \
    'OUTPUT_FORMAT(elf64-littleaarch64) ld-fil1-aarch64.so' "$(_fyg aarch64)"


# ---- specs: running the script -------------------------------------------------

test_section 'build.sh -- executed versus sourced'

expect '--help prints the header' '# Fil-C-Light build driver.' \
    "$(bash "$_root/build.sh" --help | sed -n 2p)"
expect_returns 'an unknown flag exits with 2' 2 bash "$_root/build.sh" --bogus
expect 'sourcing it runs no driver' unset \
    "$(cd "$_sb" && bash -c ". '$_root/build.sh'; echo \${MODE:-unset}")"

ROOT=$_real_root
rm -rf "$_sb"
test_end
