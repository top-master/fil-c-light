#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("avx"))) int main(void)
{
    v4sf a = { 1.0f, 2.0f, 3.0f, 4.0f };
    v4sf b = { 5.0f, 6.0f, 7.0f, 8.0f };
    v4sf result;

    /* VUNPCKLPS: interleaves the low-order single-precision elements.
       dest = { src1[0], src2[0], src1[1], src2[1] } */
    asm volatile("vunpcklps %2, %1, %0" : "=x"(result) : "x"(a), "x"(b));

    ZASSERT(result[0] == 1.0f);
    ZASSERT(result[1] == 5.0f);
    ZASSERT(result[2] == 2.0f);
    ZASSERT(result[3] == 6.0f);

    return 0;
}
