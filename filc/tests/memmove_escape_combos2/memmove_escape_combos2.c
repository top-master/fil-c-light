#include <filc_test_support.h>
#include "utils.h"
#include <string.h>
static void test0(void)
{
    char* dst[4];
    char* src[4];
    src[0] = "0";
    src[1] = "1";
    src[2] = "2";
    src[3] = "3";
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    ZASSERT(!strcmp(dst[0], "0"));
    ZASSERT(!strcmp(dst[1], "1"));
    ZASSERT(!strcmp(dst[2], "2"));
    ZASSERT(!strcmp(dst[3], "3"));
}
static void test1(void)
{
    char* dst[16];
    char* src[16];
    src[0] = "0";
    src[1] = "1";
    src[2] = "2";
    src[3] = "3";
    src[4] = "4";
    src[5] = "5";
    src[6] = "6";
    src[7] = "7";
    src[8] = "8";
    src[9] = "9";
    src[10] = "10";
    src[11] = "11";
    src[12] = "12";
    src[13] = "13";
    src[14] = "14";
    src[15] = "15";
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    ZASSERT(!strcmp(dst[0], "0"));
    ZASSERT(!strcmp(dst[1], "1"));
    ZASSERT(!strcmp(dst[2], "2"));
    ZASSERT(!strcmp(dst[3], "3"));
    ZASSERT(!strcmp(dst[4], "4"));
    ZASSERT(!strcmp(dst[5], "5"));
    ZASSERT(!strcmp(dst[6], "6"));
    ZASSERT(!strcmp(dst[7], "7"));
    ZASSERT(!strcmp(dst[8], "8"));
    ZASSERT(!strcmp(dst[9], "9"));
    ZASSERT(!strcmp(dst[10], "10"));
    ZASSERT(!strcmp(dst[11], "11"));
    ZASSERT(!strcmp(dst[12], "12"));
    ZASSERT(!strcmp(dst[13], "13"));
    ZASSERT(!strcmp(dst[14], "14"));
    ZASSERT(!strcmp(dst[15], "15"));
}
static void test2(void)
{
    char* dst[4];
    char* src[4];
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)4);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    ZASSERT(!strcmp(dst[0], "0"));
    ZASSERT(!strcmp(dst[1], "1"));
    ZASSERT(!strcmp(dst[2], "2"));
    ZASSERT(!strcmp(dst[3], "3"));
}
static void test3(void)
{
    char* dst[16];
    char* src[16];
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)16);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    ZASSERT(!strcmp(dst[0], "0"));
    ZASSERT(!strcmp(dst[1], "1"));
    ZASSERT(!strcmp(dst[2], "2"));
    ZASSERT(!strcmp(dst[3], "3"));
    ZASSERT(!strcmp(dst[4], "4"));
    ZASSERT(!strcmp(dst[5], "5"));
    ZASSERT(!strcmp(dst[6], "6"));
    ZASSERT(!strcmp(dst[7], "7"));
    ZASSERT(!strcmp(dst[8], "8"));
    ZASSERT(!strcmp(dst[9], "9"));
    ZASSERT(!strcmp(dst[10], "10"));
    ZASSERT(!strcmp(dst[11], "11"));
    ZASSERT(!strcmp(dst[12], "12"));
    ZASSERT(!strcmp(dst[13], "13"));
    ZASSERT(!strcmp(dst[14], "14"));
    ZASSERT(!strcmp(dst[15], "15"));
}
static void test4(void)
{
    char* dst[4];
    char* src[4];
    opaque(src);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)4);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    ZASSERT(!strcmp(dst[0], "0"));
    ZASSERT(!strcmp(dst[1], "1"));
    ZASSERT(!strcmp(dst[2], "2"));
    ZASSERT(!strcmp(dst[3], "3"));
}
static void test5(void)
{
    char* dst[16];
    char* src[16];
    opaque(src);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)16);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    ZASSERT(!strcmp(dst[0], "0"));
    ZASSERT(!strcmp(dst[1], "1"));
    ZASSERT(!strcmp(dst[2], "2"));
    ZASSERT(!strcmp(dst[3], "3"));
    ZASSERT(!strcmp(dst[4], "4"));
    ZASSERT(!strcmp(dst[5], "5"));
    ZASSERT(!strcmp(dst[6], "6"));
    ZASSERT(!strcmp(dst[7], "7"));
    ZASSERT(!strcmp(dst[8], "8"));
    ZASSERT(!strcmp(dst[9], "9"));
    ZASSERT(!strcmp(dst[10], "10"));
    ZASSERT(!strcmp(dst[11], "11"));
    ZASSERT(!strcmp(dst[12], "12"));
    ZASSERT(!strcmp(dst[13], "13"));
    ZASSERT(!strcmp(dst[14], "14"));
    ZASSERT(!strcmp(dst[15], "15"));
}
static void test6(void)
{
    char* dst[4];
    char* src[4];
    src[0] = "0";
    src[1] = "1";
    src[2] = "2";
    src[3] = "3";
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)4);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test7(void)
{
    char* dst[16];
    char* src[16];
    src[0] = "0";
    src[1] = "1";
    src[2] = "2";
    src[3] = "3";
    src[4] = "4";
    src[5] = "5";
    src[6] = "6";
    src[7] = "7";
    src[8] = "8";
    src[9] = "9";
    src[10] = "10";
    src[11] = "11";
    src[12] = "12";
    src[13] = "13";
    src[14] = "14";
    src[15] = "15";
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)16);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test8(void)
{
    char* dst[4];
    char* src[4];
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)4);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)4);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test9(void)
{
    char* dst[16];
    char* src[16];
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)16);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)16);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test10(void)
{
    char* dst[4];
    char* src[4];
    opaque(src);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)4);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)4);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test11(void)
{
    char* dst[16];
    char* src[16];
    opaque(src);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)16);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)16);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test12(void)
{
    char* dst[4];
    char* src[4];
    opaque(dst);
    src[0] = "0";
    src[1] = "1";
    src[2] = "2";
    src[3] = "3";
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)4);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test13(void)
{
    char* dst[16];
    char* src[16];
    opaque(dst);
    src[0] = "0";
    src[1] = "1";
    src[2] = "2";
    src[3] = "3";
    src[4] = "4";
    src[5] = "5";
    src[6] = "6";
    src[7] = "7";
    src[8] = "8";
    src[9] = "9";
    src[10] = "10";
    src[11] = "11";
    src[12] = "12";
    src[13] = "13";
    src[14] = "14";
    src[15] = "15";
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)16);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test14(void)
{
    char* dst[4];
    char* src[4];
    opaque(dst);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)4);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)4);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test15(void)
{
    char* dst[16];
    char* src[16];
    opaque(dst);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)16);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)16);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test16(void)
{
    char* dst[4];
    char* src[4];
    opaque(dst);
    opaque(src);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)4);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 4 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)4);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
}
static void test17(void)
{
    char* dst[16];
    char* src[16];
    opaque(dst);
    opaque(src);
    unsigned src_index;
    for (src_index = (unsigned)opaque(0); 
         src_index < (unsigned)opaque((void*)16);
         ++src_index)
        src[src_index] = zasprintf("%d", src_index);
    zmemmove_builtin(dst, src, 16 * sizeof(char*));
    unsigned dst_index;
    for (dst_index = (unsigned)opaque(0); 
         dst_index < (unsigned)opaque((void*)16);
         ++dst_index)
        ZASSERT(!strcmp(dst[dst_index], zasprintf("%d", dst_index)));
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
    return 0;
}
