#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 8.0f, 6.0f, 4.0f, 2.0f };
    v4sf b = { 16.0f, 12.0f, 8.0f, 4.0f };

    /* UNPCKLPS: dest = { src1[0], src2[0], src1[1], src2[1] } */
    asm volatile("unpcklps %1, %0" : "+x"(a) : "x"(b));

    ZASSERT(a[0] == 8.0f);
    ZASSERT(a[1] == 16.0f);
    ZASSERT(a[2] == 6.0f);
    ZASSERT(a[3] == 12.0f);

    return 0;
}
