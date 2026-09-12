#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

__attribute__((target("avx"))) int main(void)
{
    v2df a = { 2.0, 1.0 };
    v2df b = { 4.0, 3.0 };
    v2df result;

    /* VUNPCKHPD: dest[0] = src1[1], dest[1] = src2[1] */
    asm volatile("vunpckhpd %2, %1, %0" : "=x"(result) : "x"(a), "x"(b));

    ZASSERT(result[0] == 1.0);
    ZASSERT(result[1] == 3.0);

    return 0;
}
