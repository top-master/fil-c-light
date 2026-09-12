#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

__attribute__((target("ssse3"))) int main(void)
{
    /* PHSUBW: horizontal subtract of 16-bit words. */
    {
        v8hi a = { 10, 3, 20, 5, 30, 7, 40, 9 };
        v8hi b = { 50, 11, 60, 13, 70, 15, 80, 17 };
        asm volatile("phsubw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 7);
        ZASSERT(a[1] == 15);
        ZASSERT(a[2] == 23);
        ZASSERT(a[3] == 31);
        ZASSERT(a[4] == 39);
        ZASSERT(a[5] == 47);
        ZASSERT(a[6] == 55);
        ZASSERT(a[7] == 63);
    }

    /* PHSUBD: horizontal subtract of 32-bit dwords. */
    {
        v4si a = { 10, 3, 20, 5 };
        v4si b = { 30, 7, 40, 9 };
        asm volatile("phsubd %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 7);
        ZASSERT(a[1] == 15);
        ZASSERT(a[2] == 23);
        ZASSERT(a[3] == 31);
    }

    /* PHSUBSW: horizontal subtract with saturation of 16-bit words. */
    {
        v8hi a = { 10, 3, 20, 5, 30, 7, 40, 9 };
        v8hi b = { 50, 11, 60, 13, 70, 15, 80, 17 };
        asm volatile("phsubsw %1, %0" : "+x"(a) : "x"(b));
        ZASSERT(a[0] == 7);
        ZASSERT(a[1] == 15);
        ZASSERT(a[2] == 23);
        ZASSERT(a[3] == 31);
        ZASSERT(a[4] == 39);
        ZASSERT(a[5] == 47);
        ZASSERT(a[6] == 55);
        ZASSERT(a[7] == 63);
    }

    return 0;
}
