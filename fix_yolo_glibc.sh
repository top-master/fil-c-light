#!/bin/bash
#
# Copyright (c) 2025 Epic Games, Inc. All Rights Reserved.
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

if test `basename $PWD` != pizlonated-yolo-glibc-build
then
    echo "Please run this script from the pizlonated-yolo-glibc-build directory."
    exit 1
fi

. ../libpas/common.sh

set -e
set -x

cd ../pizfix

OLDLDNAME=ld-linux-${ARCH//_/-}.so.2
OLDLIBCIMPLNAME=libc.so.6
OLDLIBCNONSHAREDNAME=libc_nonshared.a
OLDLIBMIMPLNAME=libm.so.6
OLDSTATICLIBCNAME=libc.a
OLDSTATICLIBMNAME=libm.a

LDNAME=ld-fil1-$ARCH.so
LIBNAMEBASE=libyolo
LIBCNAMEBASE=${LIBNAMEBASE}c
LIBCNAME=${LIBCNAMEBASE}.so
LIBCIMPLNAME=${LIBCNAMEBASE}impl.so
LIBCNONSHAREDNAME=${LIBCNAMEBASE}_nonshared.a
LIBMIMPLNAME=${LIBNAMEBASE}mimpl.so
LIBMNAME=${LIBNAMEBASE}m.so
STATICLIBCNAME=${LIBCNAMEBASE}.a
STATICLIBMNAME=${LIBNAMEBASE}m.a

mkdir -p lib
cp yolo/lib/$OLDLDNAME lib/$LDNAME
cp yolo/lib/$OLDLIBCIMPLNAME lib/$LIBCIMPLNAME
cp yolo/lib/$OLDLIBCNONSHAREDNAME lib/$LIBCNONSHAREDNAME
cp yolo/lib/$OLDLIBMIMPLNAME lib/$LIBMIMPLNAME
cp yolo/lib/*.o lib/
cp yolo/lib/$OLDSTATICLIBCNAME lib/$STATICLIBCNAME
cp yolo/lib/$OLDSTATICLIBMNAME lib/$STATICLIBMNAME
patchelf --replace-needed $OLDLDNAME $LDNAME lib/$LIBCIMPLNAME
patchelf --set-soname $LIBCIMPLNAME lib/$LIBCIMPLNAME
patchelf --set-soname $LDNAME lib/$LDNAME
patchelf --replace-needed $OLDLDNAME $LDNAME lib/$LIBMIMPLNAME
patchelf --replace-needed $OLDLIBCIMPLNAME $LIBCIMPLNAME lib/$LIBMIMPLNAME
patchelf --set-soname $LIBMIMPLNAME lib/$LIBMIMPLNAME
echo "OUTPUT_FORMAT(elf64-x86-64)" > lib/$LIBCNAME
echo "GROUP ( $PWD/lib/$LIBCIMPLNAME $PWD/lib/$LIBCNONSHAREDNAME  AS_NEEDED ( $PWD/lib/$LDNAME ) )" >> lib/$LIBCNAME
echo "OUTPUT_FORMAT(elf64-x86-64)" > lib/$LIBMNAME
echo "GROUP ( $PWD/lib/$LIBMIMPLNAME )" >> lib/$LIBMNAME

rm -rf yolo-include
mv yolo/include yolo-include
rm -rf yolo
