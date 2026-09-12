#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef double v2df __attribute__((vector_size(16)));
typedef double v4df __attribute__((vector_size(32)));

__attribute__((target("avx2"))) int main(void)
{
    /* VBROADCASTSS (128-bit, AVX2): broadcast the low single-precision
       element of the source register to all four locations in the
       destination register. */
    v4sf a = { 1.0f, 2.0f, 3.0f, 4.0f };
    v4sf b;
    asm volatile("vbroadcastss %1, %0" : "=x"(b) : "x"(a));
    ZASSERT(b[0] == 1.0f);
    ZASSERT(b[1] == 1.0f);
    ZASSERT(b[2] == 1.0f);
    ZASSERT(b[3] == 1.0f);

    /* VBROADCASTSD (256-bit, AVX2): broadcast the low double-precision
       element of the source register to all four locations in the
       destination ymm register. */
    v2df src = { 7.0, 9.0 };
    v4df dst;
    asm volatile("vbroadcastsd %1, %0" : "=x"(dst) : "x"(src));
    ZASSERT(dst[0] == 7.0);
    ZASSERT(dst[1] == 7.0);
    ZASSERT(dst[2] == 7.0);
    ZASSERT(dst[3] == 7.0);

    return 0;
}
