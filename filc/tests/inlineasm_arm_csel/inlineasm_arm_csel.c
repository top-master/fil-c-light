#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* csel across conditions. */
    asm volatile("cmp %w1, %w2\n\tcsel %0, %1, %2, eq" : "=r"(r) : "r"(10UL), "r"(20UL) : "cc");
    ZASSERT(r == 20);

    asm volatile("cmp %w1, %w2\n\tcsel %0, %1, %2, ne" : "=r"(r) : "r"(10UL), "r"(10UL) : "cc");
    ZASSERT(r == 10);

    asm volatile("cmp %x1, %x2\n\tcsel %0, %1, %2, gt" : "=r"(r) : "r"(5L), "r"(2L) : "cc");
    ZASSERT(r == 5);

    asm volatile("cmp %x1, %x2\n\tcsel %0, %1, %2, lt" : "=r"(r) : "r"(5L), "r"(2L) : "cc");
    ZASSERT(r == 2);

    asm volatile("cmp %x1, %x2\n\tcsel %0, %1, %2, hs" : "=r"(r) : "r"(3UL), "r"(7UL) : "cc");
    ZASSERT(r == 7);

    asm volatile("cmp %w1, %w2\n\tcsel %w0, %w1, %w2, le" : "=r"(r) : "r"(2UL), "r"(2UL) : "cc");
    ZASSERT(r == 2);

    /* csinc: cond ? n : m + 1. */
    asm volatile("cmp %w1, #0\n\tcsinc %0, %1, %2, eq" : "=r"(r) : "r"(42UL), "r"(9UL) : "cc");
    ZASSERT(r == 10); /* eq is false for 42 != 0, so m + 1 */

    asm volatile("cmp %w1, #0\n\tcsinc %0, %1, %2, ne" : "=r"(r) : "r"(42UL), "r"(9UL) : "cc");
    ZASSERT(r == 42); /* ne is true, so n */

    /* csinv: cond ? n : ~m. */
    asm volatile("cmp %w1, #0\n\tcsinv %0, %1, %2, eq" : "=r"(r) : "r"(42UL), "r"(9UL) : "cc");
    ZASSERT(r == 0xFFFFFFFFFFFFFFF6UL);

    asm volatile("cmp %w1, #0\n\tcsinv %0, %1, %2, ne" : "=r"(r) : "r"(42UL), "r"(9UL) : "cc");
    ZASSERT(r == 42); /* ne is true, so n */

    /* csneg: cond ? n : -m. */
    asm volatile("cmp %w1, #0\n\tcsneg %0, %1, %2, eq" : "=r"(r) : "r"(42L), "r"(9L) : "cc");
    ZASSERT(r == (unsigned long)-9L);

    asm volatile("cmp %w1, #0\n\tcsneg %0, %1, %2, ne" : "=r"(r) : "r"(42L), "r"(9L) : "cc");
    ZASSERT(r == 42);

    /* cinc/cinv/cneg aliases. */
    asm volatile("cmp %w1, #5\n\tcinc %0, %1, ne" : "=r"(r) : "r"(7UL) : "cc");
    ZASSERT(r == 8);

    asm volatile("cmp %w1, #5\n\tcinv %0, %1, ne" : "=r"(r) : "r"(7UL) : "cc");
    ZASSERT(r == 0xFFFFFFFFFFFFFFF8UL);

    asm volatile("cmp %w1, #5\n\tcneg %0, %1, ne" : "=r"(r) : "r"(7L) : "cc");
    ZASSERT(r == (unsigned long)-7L);

    /* Same-register destinations. */
    asm volatile("cmp %w1, #0\n\tcsel %0, %1, %1, eq" : "=r"(r) : "r"(99UL) : "cc");
    ZASSERT(r == 99);
    return 0;
}
