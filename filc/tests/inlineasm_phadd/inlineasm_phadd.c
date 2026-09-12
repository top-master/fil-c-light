#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

__attribute__((target("ssse3"))) int main(void)
{
    /* PHADDW: horizontal add of 16-bit words. */
    {
        v8hi a = { 0, 1, 2, 3, 4, 5, 6, 7 };
        v8hi b = { 8, 9, 10, 11, 12, 13, 14, 15 };
        asm volatile("phaddw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 1);
        ZASSERT(a[1] == 5);
        ZASSERT(a[2] == 9);
        ZASSERT(a[3] == 13);
        ZASSERT(a[4] == 17);
        ZASSERT(a[5] == 21);
        ZASSERT(a[6] == 25);
        ZASSERT(a[7] == 29);
    }

    /* PHADDD: horizontal add of 32-bit dwords. */
    {
        v4si a = { 0, 1, 2, 3 };
        v4si b = { 4, 5, 6, 7 };
        asm volatile("phaddd %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 1);
        ZASSERT(a[1] == 5);
        ZASSERT(a[2] == 9);
        ZASSERT(a[3] == 13);
    }

    /* PHADDSW: horizontal add with saturation of 16-bit words. */
    {
        v8hi a = { 0, 1, 2, 3, 4, 5, 6, 7 };
        v8hi b = { 8, 9, 10, 11, 12, 13, 14, 15 };
        asm volatile("phaddsw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 1);
        ZASSERT(a[1] == 5);
        ZASSERT(a[2] == 9);
        ZASSERT(a[3] == 13);
        ZASSERT(a[4] == 17);
        ZASSERT(a[5] == 21);
        ZASSERT(a[6] == 25);
        ZASSERT(a[7] == 29);
    }

    return 0;
}
