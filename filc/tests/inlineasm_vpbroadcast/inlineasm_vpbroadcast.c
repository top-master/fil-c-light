#include <stdfil.h>

typedef signed char v16qi __attribute__((vector_size(16)));
typedef short v8hi __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));
typedef long long v2di __attribute__((vector_size(16)));

__attribute__((target("avx2"))) int main(void)
{
    /* VPBROADCASTB (AVX2): broadcast the low byte of the source register to
       all 16 byte locations in the destination register. */
    {
        v16qi src = { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
        v16qi dst;
        asm volatile("vpbroadcastb %1, %0" : "=x"(dst) : "x"(src));
        for (int i = 0; i < 16; ++i)
            ZASSERT(dst[i] == 5);
    }

    /* VPBROADCASTW (AVX2): broadcast the low word to all 8 word locations. */
    {
        v8hi src = { 1234, 5678, 9, 10, 11, 12, 13, 14 };
        v8hi dst;
        asm volatile("vpbroadcastw %1, %0" : "=x"(dst) : "x"(src));
        for (int i = 0; i < 8; ++i)
            ZASSERT(dst[i] == 1234);
    }

    /* VPBROADCASTD (AVX2): broadcast the low dword to all 4 dword locations. */
    {
        v4si src = { 0x11223344, 0x55667788, 0x99aabbcc, 0xddeeff00 };
        v4si dst;
        asm volatile("vpbroadcastd %1, %0" : "=x"(dst) : "x"(src));
        for (int i = 0; i < 4; ++i)
            ZASSERT(dst[i] == 0x11223344);
    }

    /* VPBROADCASTQ (AVX2): broadcast the low qword to both qword locations. */
    {
        v2di src = { 0x123456789abcdef0LL, 0x0fedcba987654321LL };
        v2di dst;
        asm volatile("vpbroadcastq %1, %0" : "=x"(dst) : "x"(src));
        for (int i = 0; i < 2; ++i)
            ZASSERT(dst[i] == 0x123456789abcdef0LL);
    }

    return 0;
}
