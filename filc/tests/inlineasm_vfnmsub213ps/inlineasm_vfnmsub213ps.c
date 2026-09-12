#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v4sf a = { 2.0f, 3.0f, 4.0f, 5.0f };
    v4sf b = { 6.0f, 7.0f, 8.0f, 9.0f };
    v4sf c = { 10.0f, 11.0f, 12.0f, 13.0f };

    asm volatile("vfnmsub213ps %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    ZASSERT(a[0] == -22.0f);
    ZASSERT(a[1] == -32.0f);
    ZASSERT(a[2] == -44.0f);
    ZASSERT(a[3] == -58.0f);

    return 0;
}
