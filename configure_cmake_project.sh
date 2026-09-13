#!/bin/sh
#
# Copyright (c) 2023-2025 Epic Games, Inc. All Rights Reserved.
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
# THIS SOFTWARE IS PROVIDED BY EPIC GAMES, INC. ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL EPIC GAMES, INC. OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 

set -e
set -x

test -n "$CMAKEOPTIONS"

EXPECTEDCOOKIECONTENTS="`hostname`:$PWD ::: $CMAKEOPTIONS"
 
# Rev the cookie name anytime we want to force folks to do a 100% fresh rebuild (like when we rebase
# LLVM).
COOKIENAME=filc_cookie_2.txt

if test -e build/$COOKIENAME
then
    ACTUALCOOKIECONTENTS=`cat build/$COOKIENAME`
else
    ACTUALCOOKIECONTENTS=""
fi

if test "x$ACTUALCOOKIECONTENTS" != "x$EXPECTEDCOOKIECONTENTS"
then
    rm -rf build
    mkdir -p build

    cd build
    cmake $CMAKEOPTIONS
    
    echo "$EXPECTEDCOOKIECONTENTS" > $COOKIENAME
fi
