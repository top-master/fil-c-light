#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* ccmp: if cond holds, perform the compare; else NZCV = nzcv immediate. */
    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, #0, #0, ne\n\t"
                 "cset %0, cs"
                 : "=r"(r) : "r"(5UL) : "cc");
    ZASSERT(r == 1);

    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, #1, #0, eq\n\t"
                 "cset %0, cs"
                 : "=r"(r) : "r"(0UL) : "cc");
    /* 0 == 0, so the ccmp fires: 0 - 1 borrows, so C is clear. */
    ZASSERT(r == 0);

    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, #0, #2, eq\n\t"
                 "cset %0, cs"
                 : "=r"(r) : "r"(5UL) : "cc");
    /* 5 != 0, so the ccmp is skipped: NZCV = #2, i.e. C set. */
    ZASSERT(r == 1);

    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, #0, #0, ne\n\t"
                 "cset %0, cs"
                 : "=r"(r) : "r"(0UL) : "cc");
    ZASSERT(r == 0);

    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, #0, #8, ne\n\t"
                 "cset %0, mi"
                 : "=r"(r) : "r"(0UL) : "cc");
    /* Skipped: NZCV = #8, i.e. N set. */
    ZASSERT(r == 1);

    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, #0, #4, ne\n\t"
                 "cset %0, eq"
                 : "=r"(r) : "r"(0UL) : "cc");
    /* Skipped: NZCV = #4, i.e. Z set. */
    ZASSERT(r == 1);

    /* ccmn: if cond holds, perform cmn (additive compare). */
    asm volatile("cmp %w1, #1\n\t"
                 "ccmn %w1, #0, #0, ne\n\t"
                 "cset %0, eq"
                 : "=r"(r) : "r"(0UL) : "cc");
    /* 0 != 1, so ccmn fires: 0 + 0 == 0, so Z set. */
    ZASSERT(r == 1);

    asm volatile("cmp %w1, #0\n\t"
                 "ccmn %w1, #0, #0, eq\n\t"
                 "cset %0, cs"
                 : "=r"(r) : "r"(5UL) : "cc");
    /* 5 != 0, skipped: NZCV = #0, so C clear. */
    ZASSERT(r == 0);

    /* Register operand in ccmp. */
    asm volatile("cmp %w1, #0\n\t"
                 "ccmp %w1, %w2, #0, ne\n\t"
                 "cset %0, eq"
                 : "=r"(r) : "r"(5UL), "r"(5UL) : "cc");
    /* ccmp fires: 5 == 5, so Z set. */
    ZASSERT(r == 1);
    return 0;
}
