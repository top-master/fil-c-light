#include <stdfil.h>

typedef unsigned short v8hi __attribute__((vector_size(16)));

__attribute__((target("sse4.1"))) int main(void)
{
    /* PHMINPOSUW: find minimum unsigned word; value in low word, index in
     * bits 16-18, remainder zeroed. */
    {
        v8hi a = { 5, 3, 8, 1, 9, 2, 7, 4 };
        v8hi r;
        asm volatile("phminposuw %1, %0" : "=x"(r) : "x"(a));
        ZASSERT(r[0] == 1);  /* minimum value */
        ZASSERT(r[1] == 3);  /* index of minimum */
        ZASSERT(r[2] == 0);
        ZASSERT(r[3] == 0);
        ZASSERT(r[4] == 0);
        ZASSERT(r[5] == 0);
        ZASSERT(r[6] == 0);
        ZASSERT(r[7] == 0);
    }

    /* Minimum is at index 0. */
    {
        v8hi a = { 1, 5, 8, 3, 9, 2, 7, 4 };
        v8hi r;
        asm volatile("phminposuw %1, %0" : "=x"(r) : "x"(a));
        ZASSERT(r[0] == 1);
        ZASSERT(r[1] == 0);
        ZASSERT(r[2] == 0);
        ZASSERT(r[3] == 0);
        ZASSERT(r[4] == 0);
        ZASSERT(r[5] == 0);
        ZASSERT(r[6] == 0);
        ZASSERT(r[7] == 0);
    }

    return 0;
}
