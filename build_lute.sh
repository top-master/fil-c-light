#!/bin/sh
#
# Copyright (c) 2026 Filip Pizlo. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY FILIP PIZLO ``AS IS AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL FILIP PIZLO OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

. libpas/common.sh

set -e
set -x

cd projects/lute-1.0.0
extract_source

PIZFIX=$PWD/../../../pizfix

# Bootstrap the generated embedding files. The real embeddings (C++ arrays holding
# the in-tree .luau sources) are produced by lute itself via
# 'lute tools/luthier.luau generate', so seed the tree with the stub templates from
# tools/templates/, build a throwaway lute (lute0), and use it to regenerate the
# real embeddings below. This is the offline, deterministic equivalent of
# tools/bootstrap.sh. Note that we must never run any other luthier subcommand
# here: 'fetch' would delete and re-clone extern/, which is vendored in this repo.
mkdir -p lute/std/src/generated lute/cli/generated lute/batteries/generated lute/definitions/src/generated
cp tools/templates/std_impl.cpp lute/std/src/generated/modules.cpp
cp tools/templates/std_header.h lute/std/src/generated/modules.h
cp tools/templates/cli_impl.cpp lute/cli/generated/commands.cpp
cp tools/templates/cli_header.h lute/cli/generated/commands.h
cp tools/templates/batteries_impl.cpp lute/batteries/generated/batteries.cpp
cp tools/templates/batteries_header.h lute/batteries/generated/batteries.h
cp tools/templates/definitions_impl.cpp lute/definitions/src/generated/modules.cpp
cp tools/templates/definitions_header.h lute/definitions/src/generated/modules.h

# Use pizfix's Fil-C libuv, zlib, OpenSSL and curl (the vendored extern/libuv,
# extern/zlib, extern/boringssl and extern/curl were all removed from this
# port; all four LUTE_SYSTEM_* options are required). Use absolute paths,
# since cmake caches them.
CC="$PWD/../../../build/bin/clang -g" CXX="$PWD/../../../build/bin/clang++ -g" \
    cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release \
    -DLUTE_SYSTEM_LIBUV=$PIZFIX \
    -DLUTE_SYSTEM_ZLIB=$PIZFIX \
    -DLUTE_SYSTEM_OPENSSL=$PIZFIX \
    -DLUTE_SYSTEM_CURL=$PIZFIX

# Build lute0 (stub embeddings), regenerate the real embeddings with it, then
# rebuild so the final binary embeds the actual stdlib/commands/batteries/
# definitions.
ninja -C build -j $NCPU lute/cli/lute
build/lute/cli/lute tools/luthier.luau generate
ninja -C build -j $NCPU lute/cli/lute

cp build/lute/cli/lute $PIZFIX/bin/

# Validation. Everything below runs against the installed binary.

SCRATCH=`mktemp -d`
trap "rm -rf $SCRATCH" EXIT

# Smoke test: version reporting plus a hello world, run from a neutral directory
# (the @std/@lute modules are embedded in the binary, so no project tree is
# needed).
$PIZFIX/bin/lute --version
cat > $SCRATCH/hello.luau <<'EOF'
print("hello from lute")
EOF
(cd $SCRATCH && $PIZFIX/bin/lute hello.luau)

# fs/process smoke test: write+read a file and run a subprocess.
cat > $SCRATCH/fs_process_smoke.luau <<'EOF'
local fs = require("@std/fs")
local path = require("@std/path")
local process = require("@std/process")
local system = require("@std/system")

local file = path.join(system.tmpdir(), "lute_fs_process_smoke.txt")
local handle = fs.open(file, "w+")
fs.write(handle, "lute-fs-smoke")
fs.close(handle)
assert(fs.readFileToString(file) == "lute-fs-smoke", "fs readback mismatch")
fs.remove(file)

local result = process.run({ "echo", "lute-process-smoke" })
assert(result.stdout == "lute-process-smoke\n", "process.run mismatch")

print("lute fs/process smoke: OK")
EOF
(cd $SCRATCH && $PIZFIX/bin/lute fs_process_smoke.luau)

# GC churn: allocate millions of short-lived tables, strings, and closures for
# ~GC_CHURN_BUDGET seconds of wall time. lute's sandbox has no collectgarbage
# (Luau only defines it in its standalone REPL), so just churn hard and let both
# Luau's GC and Fil-C's FUGC do their thing; use collectgarbage if it ever shows
# up. The second run sets FUGC_MIN_THRESHOLD=0, which makes FUGC collect
# constantly, with a smaller budget since that is much slower.
cat > $SCRATCH/gc_churn.luau <<'EOF'
local process = require("@std/process")

local budget = tonumber(process.env.GC_CHURN_BUDGET) or 15
local gc = collectgarbage -- nil in lute's sandbox; use it if present

local start = os.clock()
local rounds = 0
local live = {}

while os.clock() - start < budget do
    for i = 1, 100000 do
        local t = { i, tostring(i), nested = { x = i, y = tostring(i * 2) } }
        local f = function()
            return t[1] + i
        end
        live[1 + i % 16] = f -- keep a few live, toss the rest
    end
    rounds += 1
    if gc then
        gc("collect")
    end
    print(string.format("gc-churn: round %d done, %.1fs elapsed", rounds, os.clock() - start))
end

print(string.format("gc-churn: OK, %d rounds (%d objects) in %.1fs", rounds, rounds * 100000, os.clock() - start))
EOF
(cd $SCRATCH && $PIZFIX/bin/lute gc_churn.luau)
(cd $SCRATCH && GC_CHURN_BUDGET=8 FUGC_MIN_THRESHOLD=0 $PIZFIX/bin/lute gc_churn.luau)

# C++ unit tests (doctest). These bind no ports, so they are safe for parallel
# build_all.sh runs on different checkouts. uv_os_homedir (used by
# require.test.cpp) needs a valid HOME on glibc, so provide a fallback when HOME
# is unset or empty. Like lute's CI, drop the root .luaurc first: its aliases
# confuse the require-resolution tests. Must run from the project root so the
# tests find .LUTE_SENTINEL.
ninja -C build -j $NCPU Lute.Test
rm -f .luaurc
HOME="${HOME:-$PWD}" ./build/tests/lute-tests

# Luau test suite. We run every test file except tests/std/net.test.luau: that
# file calls server.serve() with no port, which binds the fixed port 3000. It's a
# P1 that build_all.sh can run multiple times in parallel on different checkouts
# of this repo (see the comment in build_libuv.sh), and binding a fixed port
# would break that. (tests/lute/net.test.luau is fine: it binds port 0, i.e. an
# ephemeral port.) Runs from the project root; 'lute test' takes the test
# files/directories to run as arguments.
$PIZFIX/bin/lute test \
    tests/batteries \
    tests/cli \
    tests/lute \
    tests/std/fs.test.luau \
    tests/std/io.test.luau \
    tests/std/json.test.luau \
    tests/std/luau.test.luau \
    tests/std/path \
    tests/std/process.test.luau \
    tests/std/stringext.test.luau \
    tests/std/syntax \
    tests/std/tableext.test.luau \
    tests/std/test.test.luau \
    tests/std/time.test.luau
