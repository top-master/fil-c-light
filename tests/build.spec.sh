#!/usr/bin/env bash

# License: Apache 2.0 without attribution need.

# Self-test for `build.sh`. Sources the script (its driver runs only when it is
# executed) and exercises every function whose behaviour does not need a real
# LLVM or Fil-C build: argument parsing, the compiler repo and token lookup, the
# build-folder mirror, syncing built portions into the tree, the clang linkage
# checks, and publishing on a fake GitHub (a `curl` stand-in, no network).
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
_real_root=$ROOT

test_begin 'build.spec'


# ---- specs: filc_parse_args ---------------------------------------------

test_section 'filc_parse_args -- modes and flags'

_parse() { unset BUILD_DIR; filc_parse_args "$@"; }

_parse
expect 'default mode fetches a prebuilt toolchain' download "$MODE"
expect 'default build folder is ../build/<tree name>' \
    "$(dirname "$ROOT")/build/$(basename "$ROOT")" "$BUILD_DIR"
_parse --nightly
expect '--nightly builds from source' source "$MODE"
for _f in --universal --static --general; do
    _parse "$_f"
    expect "$_f builds from source, universal" 'source static' "$MODE $STATIC"
done
_parse --publish
expect '--publish alone builds from source, then publishes' 'source 1' "$MODE $PUBLISH"
_parse --upload
expect '--upload is the same as --publish' 'source 1' "$MODE $PUBLISH"
_parse --no-xz
expect '--no-xz sets its flag' 1 "$NOXZ"
_parse --no-archive
expect '--no-archive is the same as --no-xz' 1 "$NOXZ"
_parse --nightly
expect 'a build publishes and syncs by default' '1 1' "$PUBLISH $SYNC"
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
        filc_make_archive() { ls "$TOOLS"/.run-start.* 2>/dev/null | wc -l | tr -d " "; exit 0; }
        filc_main "$@" 2>/dev/null
    )
}
expect 'a clean-only run makes no marker (and does not wait)' 0 "$(_marker_count --clean)"
expect 'an export makes one' 1 "$(_marker_count --export)"

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
expect '--no-publish cancels a bare --publish' download "$MODE"

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
expect_returns '--no-build alone has nothing to do' 2 filc_parse_args --no-build

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
expect '--rebuild after --no-build builds again' 'source 1' "$MODE $PUBLISH"
_parse --universal --rebuild=pas
expect '--rebuild keeps --universal' 'source static' "$MODE $STATIC"

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
expect '--clean with --publish cleans, then builds and publishes' 'source 1' "$MODE $PUBLISH"
_parse --nightly --clean=pas --no-build
expect '--clean --no-build only cleans' clean "$MODE"
_parse --rebuild=crt
expect '--rebuild sets the same filter as --clean' 'source crt' "$MODE $FILC_CLEAN_FILTER"
expect_returns '--no-build --no-publish has nothing to do' 2 filc_parse_args --no-build --publish --no-publish
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


# ---- specs: platform identity ---------------------------------------------

test_section 'filc_detect_platform'

printf 'NAME="Some Linux"\nID=somelinux\nVERSION="9 (nine)"\n' > "$_sb/os-release"
unset NAME VERSION
FILC_OS_RELEASE=$_sb/os-release filc_detect_platform
expect 'the distro id and the machine name the host platform' "somelinux-$(uname -m)" "$PLAT"
expect 'the universal platform names only the machine' "linux-universal-$(uname -m)" "$UNIVERSAL_PLAT"
expect 'os-release variables stay out of the script' '' "${NAME:-}${VERSION:-}"
FILC_OS_RELEASE=$_sb/no-such-file filc_detect_platform
expect 'without os-release the distro is plain linux' "linux-$(uname -m)" "$PLAT"
unset FILC_OS_RELEASE


# ---- specs: compiler repo, release URL, token ------------------------------

# _repo <dir> [<remote> <url>]...: a git repo at <dir> with the given remotes.
_repo() {
    _d=$1; shift
    rm -rf "$_d"; mkdir -p "$_d"
    git -C "$_d" init -q
    while [ $# -gt 1 ]; do git -C "$_d" remote add "$1" "$2"; shift 2; done
}

test_section 'filc_compiler_repo_slug / filc_release_base_url'

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
expect 'the release URL is derived from the compiler repo' \
    https://github.com/owner/fil-c-llvm/releases/latest/download "$(filc_release_base_url)"
expect 'FILC_LIGHT_RELEASE_URL overrides it' https://mirror/x \
    "$(FILC_LIGHT_RELEASE_URL=https://mirror/x filc_release_base_url)"

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
ROOT=$_sb/dl-tree; TOOLS=$_sb/dl-tools
PLAT=ubuntu-x86_64; UNIVERSAL_PLAT=linux-universal-x86_64
_archive() {   # $1 = file name, $2 = text the fake clang prints
    rm -rf "$_sb/pack"; mkdir -p "$_sb/pack/build/bin" "$_sb/pack/pizfix/lib"
    printf '#!/bin/sh\necho "%s"\n' "$2" > "$_sb/pack/build/bin/clang"
    chmod +x "$_sb/pack/build/bin/clang"
    : > "$_sb/pack/pizfix/lib/libpizlo.so"
    tar -C "$_sb/pack" -cJf "$_srv/$1" build pizfix
}
_no_url_download() {   # no env URL and no GitHub compiler repo
    unset FILC_LIGHT_RELEASE_URL
    filc_compiler_repo_slug() { :; }
    filc_download_toolchain
}
expect_returns 'with no release URL it gives up' 1 _no_url_download
export FILC_LIGHT_RELEASE_URL=https://srv/dl
expect_returns 'with no archive for the platform it gives up' 1 filc_download_toolchain
_archive filc-linux-universal-x86_64.xz universal
rm -rf "$ROOT"; mkdir -p "$ROOT"
expect_returns 'the universal archive serves when the distro one is missing' 0 filc_download_toolchain
expect 'and is unpacked into the tree' 'universal yes' \
    "$("$ROOT/build/bin/clang") $([ -f "$ROOT/pizfix/lib/libpizlo.so" ] && echo yes)"
_archive filc-ubuntu-x86_64.xz distro
rm -rf "$ROOT"; mkdir -p "$ROOT"
filc_download_toolchain > /dev/null
expect 'the distro archive is preferred when both exist' distro "$("$ROOT/build/bin/clang")"
expect 'the downloaded archive is not kept' '' "$(ls "$TOOLS"/*.xz 2>/dev/null)"
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
FILC_CLEAN_FILTER='^clang$'
expect_returns 'only clang to rebuild leaves the runtime alone' 1 filc_clean_wants_runtime
FILC_CLEAN_FILTER='pas'
expect_returns 'a runtime keyword asks for the runtime' 0 filc_clean_wants_runtime
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

test_section 'filc_asset_label / the release page text'

ARCH=x86_64; PLAT=ubuntu-x86_64; UNIVERSAL_PLAT=linux-universal-x86_64
filc_clang_glibc_floor() { echo 2.38; }
expect 'a distribution asset names its distribution' 'Ubuntu x86_64 - needs glibc >= 2.38' \
    "$(filc_asset_label ubuntu-x86_64)"
expect 'the universal asset says it runs on any Linux' \
    'Any Linux x86_64 (universal) - needs glibc >= 2.38' "$(filc_asset_label linux-universal-x86_64)"
filc_clang_glibc_floor() { :; }
expect 'without a known floor the label says no glibc' 'Ubuntu x86_64' "$(filc_asset_label ubuntu-x86_64)"
filc_clang_glibc_floor() { echo 2.38; }

_page() { printf '%s' "$1" | python3 -c "$FILC_PAGE_PY" 0.685 x86_64 20; }
_rel='{"name": "", "body": "", "assets": [
  {"name": "filc-linux-universal-x86_64.xz", "label": "Any Linux x86_64 (universal) - needs glibc >= 2.38"},
  {"name": "filc-ubuntu-x86_64.xz", "label": ""}]}'
_out=$(_page "$_rel")
_body=$(printf '%s' "$_out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["body"])')
expect 'the page names the release after the version' 'Fil-C 0.685 prebuilt toolchain (x86_64)' \
    "$(printf '%s' "$_out" | python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])')"
expect 'each asset is listed, the universal one last, unlabelled ones by name' \
    "- \`filc-ubuntu-x86_64.xz\`: Ubuntu x86_64
- \`filc-linux-universal-x86_64.xz\`: Any Linux x86_64 (universal) - needs glibc >= 2.38" \
    "$(printf '%s\n' "$_body" | grep '^- ')"
expect "the build.sh sentence is a paragraph of its own" yes \
    "$(printf '%s\n' "$_body" | grep -q "^\`filc-light\`'s \`build.sh\` fetches" && echo yes)"
_same=$(printf '%s' "$_out" | python3 -c '
import json, sys
p = json.load(sys.stdin); r = json.loads(sys.argv[1]); r.update(p); print(json.dumps(r))' "$_rel")
expect 'an up-to-date page asks for no change' '' "$(_page "$_same")"

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
echo one > "$DIST/filc-linux-universal-x86_64.xz"

_log=$(filc_upload_archive linux-universal-x86_64 2>&1)
expect 'a missing release is created' 1 "$(printf '%s\n' "$_log" | grep -c '^publish: creating release v0.685')"
expect 'the archive is uploaded with its label' \
    'filc-linux-universal-x86_64.xz|Any Linux x86_64 (universal) - needs glibc >= 2.38' \
    "$(_rel_get '"|".join([r["assets"][0]["name"], r["assets"][0]["label"]])')"
expect 'the page is regenerated from the assets' 'Fil-C 0.685 prebuilt toolchain (x86_64) yes' \
    "$(_rel_get 'r["name"] + (" yes" if "filc-linux-universal-x86_64.xz" in r["body"] else " no")')"
_log=$(filc_upload_archive linux-universal-x86_64 2>&1)
expect 'an identical asset is kept, only relabelled' '1 1' \
    "$(printf '%s\n' "$_log" | grep -c 'same sha256'; ) $(_rel_get 'len(r["assets"])')"
expect 'an unchanged page is left alone' 1 \
    "$(printf '%s\n' "$_log" | grep -c 'is up to date')"
echo two > "$DIST/filc-linux-universal-x86_64.xz"
_log=$(filc_upload_archive linux-universal-x86_64 2>&1)
expect 'a different archive replaces the older asset' "1 1 sha256:$(sha256sum "$DIST/filc-linux-universal-x86_64.xz" | cut -d' ' -f1)" \
    "$(printf '%s\n' "$_log" | grep -c 'replacing the older') $(_rel_get 'str(len(r["assets"])) + " " + r["assets"][0]["digest"]')"
expect 'the token never appears on a curl command line' 0 \
    "$(grep -c SECRET-TOKEN "$_gh/argv.log")"
expect 'no token header file is left behind' 0 \
    "$(grep -o -- '-H @[^ ]*' "$_gh/argv.log" | sed 's/-H @//' | sort -u | while read -r f; do [ -e "$f" ] && echo "$f"; done | wc -l | tr -d ' ')"
git -C "$ROOT/compiler" remote set-url origin https://github.com/owner/fil-c-llvm.git
git -C "$ROOT" remote set-url origin https://github.com/owner/fil-c-light.git
expect_returns 'without a token publishing is skipped, not failed' 0 \
    filc_upload_archive linux-universal-x86_64
expect 'and it says why' 1 \
    "$(filc_upload_archive linux-universal-x86_64 2>&1 | grep -c 'carries an access token; skipping')"
unset -f curl


# ---- specs: what a build runs ---------------------------------------------------

test_section 'filc_main -- the steps a from-source build runs'

# Every build step stubbed: each one only says its name; packing writes a small, valid
# archive unless _PACK says otherwise (none: writes nothing, bad: writes a non-xz file).
_steps_run() {
    (
        filc_install_bison() { :; }
        filc_mirror() { mkdir -p "$BUILD_DIR/pizfix/lib"; : > "$BUILD_DIR/pizfix/lib/libpizlo.so"; }
        filc_build_clang() { echo clang; }
        filc_build_runtime_libc() { echo runtime; }
        filc_sync_all() { echo sync; }
        filc_make_archive() {
            echo pack
            mkdir -p "$DIST"
            case "${_PACK:-}" in
                none) ;;
                bad)  echo garbage > "$DIST/filc-$1.xz" ;;
                *)    printf x | xz > "$DIST/filc-$1.xz" ;;
            esac
        }
        filc_upload_archive() { echo publish; }
        BUILD_DIR=$_sb/steps-ws; DIST=$_sb/steps-dist; TOOLS=$_sb/steps-tools
        filc_main "$@"
    )
}
_steps() {
    _steps_run "$@" 2>/dev/null | grep -E '^(clang|runtime|sync|pack|publish)$' | tr '\n' ' ' | sed 's/ $//'
}
expect 'by default a build syncs, packs and publishes' 'clang runtime sync pack publish' "$(_steps --nightly)"
expect '--no-sync leaves the tree alone' 'clang runtime pack publish' "$(_steps --nightly --no-sync)"
expect '--no-publish keeps the archive local' 'clang runtime sync pack' "$(_steps --nightly --no-publish)"
expect '--no-upload then --publish publishes again' 'clang runtime sync pack publish' \
    "$(_steps --nightly --no-upload --publish)"
expect '--no-xz neither packs nor publishes' 'clang runtime sync' "$(_steps --nightly --no-xz)"
expect '--no-xz wins over --publish: nothing is packed, nothing published' 'clang runtime sync' \
    "$(_steps --nightly --no-xz --publish)"
expect_returns 'and that run still succeeds' 0 _steps_run --nightly --no-xz --publish
expect 'a bare --publish builds, then publishes the fresh archive' 'clang runtime sync pack publish' \
    "$(_steps --publish)"
expect 'a universal build reuses an existing runtime' 'clang sync pack publish' \
    "$(_steps --universal)"
expect 'a universal --rebuild of a runtime portion rebuilds the runtime' \
    'clang runtime sync pack publish' "$(_steps --universal --rebuild=pas)"
expect 'a universal --rebuild=clang still reuses the runtime' 'clang sync pack publish' \
    "$(_steps --universal --rebuild=clang)"
expect 'a universal bare --rebuild rebuilds the runtime too' 'clang runtime sync pack publish' \
    "$(_steps --universal --rebuild)"

test_section 'filc_main -- only a fresh, valid archive is published'

rm -rf "$_sb/steps-dist"
expect 'a pack that wrote nothing publishes nothing' 'clang runtime sync pack' "$(_PACK=none _steps --nightly)"
_PACK=none
expect_returns 'and the run fails' 1 _steps_run --nightly
unset _PACK
expect_returns 'a valid fresh archive lets the run succeed' 0 _steps_run --nightly
mkdir -p "$_sb/steps-dist"
printf x | xz > "$_sb/steps-dist/filc-$(. /etc/os-release 2>/dev/null; echo "${ID:-linux}")-$(uname -m).xz"
touch -d 2000-01-01 "$_sb/steps-dist"/*.xz
expect 'an archive older than the run is not published' 'clang runtime sync pack' "$(_PACK=none _steps --nightly)"
expect 'a corrupt archive is not published' 'clang runtime sync pack' "$(_PACK=bad _steps --nightly)"


test_section 'filc_build_clang -- --rebuild=clang starts from scratch'

# filc_build_clang with cmake, ninja and patchelf stubbed: "building" writes a clang that
# needs the shared libstdc++ (the host-only linkage), so a plain run finds it already built.
_clang_run() {   # $@ = filc_parse_args flags
    (
        cmake() { :; }
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
printf 'LLVMARCH=X86\nNCPU=1\n' > "$_sb/clang-ws/libpas/common.sh"
cp "$_sb/cxx-or-true" "$_sb/clang-ws/build/bin/clang-20"
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

test_section 'filc_main --export -- archive only, no build, no publishing'

ROOT=$_sb/exp-tree; BUILD_DIR=$_sb/exp-ws; DIST=$ROOT/dist; TOOLS=$_sb/exp-tools
mkdir -p "$ROOT/build/bin" "$ROOT/build/lib/clang/20/include" "$ROOT/pizfix/lib"
printf '#!/bin/sh\necho clang\n' > "$ROOT/build/bin/clang-20"
chmod +x "$ROOT/build/bin/clang-20"
: > "$ROOT/build/lib/clang/20/include/stddef.h"
: > "$ROOT/pizfix/lib/libpizlo.so"
expect 'without a build folder clang, the tree describes the archives' \
    "$ROOT/build/bin/clang-20" "$(filc_built_clang)"
curl() { echo called >> "$_sb/exp-curl.log"; }
( filc_main --export ) > "$_sb/exp.log" 2>&1
expect 'it names the archive after the linkage of the tree clang' \
    "filc-linux-universal-$(uname -m).xz" "$(ls "$DIST")"
expect 'the archive holds clang, its resource dir and pizfix/' \
    'build/bin/clang-20 build/lib/clang/20/include/stddef.h pizfix/lib/libpizlo.so' \
    "$(tar -tJf "$DIST"/*.xz | grep -E 'clang-20$|stddef.h$|libpizlo.so$' | sort | tr '\n' ' ' | sed 's/ $//')"
expect 'it publishes nothing' '' "$(cat "$_sb/exp-curl.log" 2>/dev/null)"
expect 'it builds nothing' '' "$(ls -d "$BUILD_DIR" 2>/dev/null)"
rm -rf "$ROOT/build"
expect_returns 'without a toolchain to pack it fails' 1 filc_main --export
unset -f curl
mkdir -p "$BUILD_DIR/build/bin"
printf '#!/bin/sh\n' > "$BUILD_DIR/build/bin/clang-20"; chmod +x "$BUILD_DIR/build/bin/clang-20"
expect "a build folder clang wins over the tree's" "$BUILD_DIR/build/bin/clang-20" "$(filc_built_clang)"


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
