#include <filc_test_support.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"
static __attribute__((noinline)) void
test0(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test1(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test2(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test3(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test4(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test5(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test6(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test7(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test8(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test9(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test10(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test11(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test12(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test13(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test14(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test15(void)
{
    int** src =
        zgc_alloc(45);
    int** origSrc = zgc_alloc(45);
    int** dst = zgc_alloc(45);
    int** origDst = zgc_alloc(45);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 45)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test16(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test17(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test18(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test19(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test20(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test21(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test22(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test23(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        39);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test24(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!opaque(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test25(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!opaque(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test26(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!opaque(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test27(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!opaque(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test28(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(zhasvalidcap(dst[0]));
    ZASSERT(opaque(dst[0]) ==
            opaque(src[0]));
    ZASSERT(*dst[0] ==
            *src[0]);
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test29(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(zhasvalidcap(dst[0]));
    ZASSERT(opaque(dst[0]) ==
            opaque(src[0]));
    ZASSERT(*dst[0] ==
            *src[0]);
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test30(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(zhasvalidcap(dst[0]));
    ZASSERT(opaque(dst[0]) ==
            opaque(src[0]));
    ZASSERT(*dst[0] ==
            *src[0]);
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test31(void)
{
    int** src =
        zgc_alloc(40);
    int** origSrc = zgc_alloc(40);
    int** dst = zgc_alloc(40);
    int** origDst = zgc_alloc(40);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    zmemmove_union(
        (char*)dst + 0,
        (char*)src + 0,
        40);
    ZASSERT(zhasvalidcap(dst[0]));
    ZASSERT(opaque(dst[0]) ==
            opaque(src[0]));
    ZASSERT(*dst[0] ==
            *src[0]);
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    size_t index;
    for (index = 40;
         index--;) {
        int** expected =
            (index >= 0 &&
             index < 40)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 5;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test32(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test33(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test34(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test35(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test36(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test37(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test38(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test39(void)
{
    int** src =
        zgc_alloc(41);
    int** origSrc = zgc_alloc(41);
    int** dst = zgc_alloc(41);
    int** origDst = zgc_alloc(41);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 1,
        (char*)src + 1,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 1 &&
             index < 41)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test40(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test41(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test42(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test43(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test44(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test45(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test46(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test47(void)
{
    int** src =
        zgc_alloc(46);
    int** origSrc = zgc_alloc(46);
    int** dst = zgc_alloc(46);
    int** origDst = zgc_alloc(46);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 6,
        (char*)src + 6,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 6 &&
             index < 46)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test48(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test49(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    src = opaque(src);
    dst = opaque(dst);
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test50(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test51(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    src = opaque(src);
    dst = opaque(dst);
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(!zhasvalidcap(dst[1]));
    ZASSERT(!opaque(dst[1]));
    ZASSERT(!zhasvalidcap(dst[2]));
    ZASSERT(!opaque(dst[2]));
    ZASSERT(!zhasvalidcap(dst[3]));
    ZASSERT(!opaque(dst[3]));
    ZASSERT(!zhasvalidcap(dst[4]));
    ZASSERT(!opaque(dst[4]));
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test52(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test53(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test54(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
static __attribute__((noinline)) void
test55(void)
{
    int** src =
        zgc_alloc(47);
    int** origSrc = zgc_alloc(47);
    int** dst = zgc_alloc(47);
    int** origDst = zgc_alloc(47);
    src = opaque(src);
    dst = opaque(dst);
    src[0] = zgc_alloc(sizeof(int));
    *src[0] = 666;
    origSrc[0] = src[0];
    dst[0] = zgc_alloc(sizeof(int));
    *dst[0] = 1410;
    origDst[0] = dst[0];
    src[1] = zgc_alloc(sizeof(int));
    *src[1] = 667;
    origSrc[1] = src[1];
    dst[1] = zgc_alloc(sizeof(int));
    *dst[1] = 1411;
    origDst[1] = dst[1];
    src[2] = zgc_alloc(sizeof(int));
    *src[2] = 668;
    origSrc[2] = src[2];
    dst[2] = zgc_alloc(sizeof(int));
    *dst[2] = 1412;
    origDst[2] = dst[2];
    src[3] = zgc_alloc(sizeof(int));
    *src[3] = 669;
    origSrc[3] = src[3];
    dst[3] = zgc_alloc(sizeof(int));
    *dst[3] = 1413;
    origDst[3] = dst[3];
    src[4] = zgc_alloc(sizeof(int));
    *src[4] = 670;
    origSrc[4] = src[4];
    dst[4] = zgc_alloc(sizeof(int));
    *dst[4] = 1414;
    origDst[4] = dst[4];
    src[5] = zgc_alloc(sizeof(int));
    *src[5] = 671;
    origSrc[5] = src[5];
    dst[5] = zgc_alloc(sizeof(int));
    *dst[5] = 1415;
    origDst[5] = dst[5];
    zmemmove_union(
        (char*)dst + 7,
        (char*)src + 7,
        40);
    ZASSERT(!zhasvalidcap(dst[0]));
    ZASSERT(zhasvalidcap(dst[1]));
    ZASSERT(opaque(dst[1]) ==
            opaque(src[1]));
    ZASSERT(*dst[1] ==
            *src[1]);
    ZASSERT(zhasvalidcap(dst[2]));
    ZASSERT(opaque(dst[2]) ==
            opaque(src[2]));
    ZASSERT(*dst[2] ==
            *src[2]);
    ZASSERT(zhasvalidcap(dst[3]));
    ZASSERT(opaque(dst[3]) ==
            opaque(src[3]));
    ZASSERT(*dst[3] ==
            *src[3]);
    ZASSERT(zhasvalidcap(dst[4]));
    ZASSERT(opaque(dst[4]) ==
            opaque(src[4]));
    ZASSERT(*dst[4] ==
            *src[4]);
    ZASSERT(!zhasvalidcap(dst[5]));
    size_t index;
    for (index = 48;
         index--;) {
        int** expected =
            (index >= 7 &&
             index < 47)
            ? src : origDst;
        ZASSERT(((char*)dst)[index] ==
                ((char*)expected)[index]);
    }
    for (index = 6;
         index--;) {
        ((int*_Atomic*)dst)[index] = zgc_alloc(0);
        ZASSERT(src[index] == origSrc[index]);
    }
}
int main()
{
    test0();
    test1();
    test2();
    test3();
    test4();
    test5();
    test6();
    test7();
    test8();
    test9();
    test10();
    test11();
    test12();
    test13();
    test14();
    test15();
    test16();
    test17();
    test18();
    test19();
    test20();
    test21();
    test22();
    test23();
    test24();
    test25();
    test26();
    test27();
    test28();
    test29();
    test30();
    test31();
    test32();
    test33();
    test34();
    test35();
    test36();
    test37();
    test38();
    test39();
    test40();
    test41();
    test42();
    test43();
    test44();
    test45();
    test46();
    test47();
    test48();
    test49();
    test50();
    test51();
    test52();
    test53();
    test54();
    test55();
    return 0;
}
