#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* cmp + cset across conditions, w and x forms. */
    asm volatile("cmp %w1, #5\n\tcset %w0, eq" : "=r"(r) : "r"(7UL) : "cc");
    ZASSERT(r == 0);

    asm volatile("cmp %w1, #7\n\tcset %w0, eq" : "=r"(r) : "r"(7UL) : "cc");
    ZASSERT(r == 1);

    asm volatile("cmp %x1, #0\n\tcset %0, eq" : "=r"(r) : "r"(0UL) : "cc");
    ZASSERT(r == 1);

    asm volatile("cmp %x1, #0\n\tcset %0, ne" : "=r"(r) : "r"(0UL) : "cc");
    ZASSERT(r == 0);

    /* Register vs register compare, signed and unsigned conditions. */
    asm volatile("cmp %x1, %x2\n\tcset %0, lt" : "=r"(r) : "r"(-3L), "r"(2L) : "cc");
    ZASSERT(r == 1);

    asm volatile("cmp %x1, %x2\n\tcset %0, lo" : "=r"(r) : "r"(3UL), "r"(5UL) : "cc");
    ZASSERT(r == 1);

    asm volatile("cmp %x1, %x2\n\tcset %0, gt" : "=r"(r) : "r"(5L), "r"(2L) : "cc");
    ZASSERT(r == 1);

    /* cmn: compare negative. */
    asm volatile("cmn %x1, #1\n\tcset %0, eq" : "=r"(r) : "r"(0xFFFFFFFFFFFFFFFFUL) : "cc");
    ZASSERT(r == 1);

    asm volatile("cmn %w1, %w2\n\tcset %w0, hs" : "=r"(r) : "r"(0xFFFFFFFFU), "r"(1U) : "cc");
    ZASSERT(r == 1);

    /* tst: bitwise test. */
    asm volatile("tst %w1, #0x8\n\tcset %w0, ne" : "=r"(r) : "r"(0xFU) : "cc");
    ZASSERT(r == 1);

    asm volatile("tst %x1, %x2\n\tcset %0, eq" : "=r"(r) : "r"(0xF0UL), "r"(0x0FUL) : "cc");
    ZASSERT(r == 1);

    /* csetm: set all bits if condition holds. */
    asm volatile("cmp %w1, #5\n\tcsetm %w0, eq" : "=r"(r) : "r"(5UL) : "cc");
    ZASSERT(r == 0xFFFFFFFFUL);

    asm volatile("cmp %w1, #5\n\tcsetm %x0, ne" : "=r"(r) : "r"(5UL) : "cc");
    ZASSERT(r == 0);

    /* cinc: add one if condition holds. */
    unsigned long v = 7;
    asm volatile("cmp %w1, #5\n\tcinc %0, %1, ne" : "=r"(r) : "r"(v) : "cc");
    ZASSERT(r == 8);

    asm volatile("cmp %w1, #5\n\tcinc %0, %1, eq" : "=r"(r) : "r"(v) : "cc");
    ZASSERT(r == 7);
    return 0;
}
