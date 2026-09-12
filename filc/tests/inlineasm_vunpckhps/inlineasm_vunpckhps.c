#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("avx"))) int main(void)
{
    v4sf a = { 1.0f, 2.0f, 3.0f, 4.0f };
    v4sf b = { 5.0f, 6.0f, 7.0f, 8.0f };
    v4sf result;

    /* VUNPCKHPS: interleaves the high-order single-precision elements.
       dest = { src1[2], src2[2], src1[3], src2[3] } */
    asm volatile("vunpckhps %2, %1, %0" : "=x"(result) : "x"(a), "x"(b));

    ZASSERT(result[0] == 3.0f);
    ZASSERT(result[1] == 7.0f);
    ZASSERT(result[2] == 4.0f);
    ZASSERT(result[3] == 8.0f);

    return 0;
}
