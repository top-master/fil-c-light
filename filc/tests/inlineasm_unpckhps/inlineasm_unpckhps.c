#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 8.0f, 6.0f, 4.0f, 2.0f };
    v4sf b = { 16.0f, 12.0f, 8.0f, 4.0f };

    /* UNPCKHPS: dest = { src1[2], src2[2], src1[3], src2[3] } */
    asm volatile("unpckhps %1, %0" : "+x"(a) : "x"(b));

    ZASSERT(a[0] == 4.0f);
    ZASSERT(a[1] == 8.0f);
    ZASSERT(a[2] == 2.0f);
    ZASSERT(a[3] == 4.0f);

    return 0;
}
