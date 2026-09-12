#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* Reading the zero register as an input operand. */
    asm volatile("add %w0, %w1, wzr" : "=r"(r) : "r"(42UL));
    ZASSERT(r == 42);

    asm volatile("add %x0, xzr, %x1" : "=r"(r) : "r"(1234UL));
    ZASSERT(r == 1234);

    asm volatile("orr %x0, xzr, %x1" : "=r"(r) : "r"(0xF0F0UL));
    ZASSERT(r == 0xF0F0);

    asm volatile("sub %w0, wzr, %w1" : "=r"(r) : "r"(5UL));
    ZASSERT(r == 0xFFFFFFFBUL);

    asm volatile("sub %x0, xzr, %x1" : "=r"(r) : "r"(5UL));
    ZASSERT(r == 0xFFFFFFFFFFFFFFFBUL);

    asm volatile("mov %w0, wzr" : "=r"(r));
    ZASSERT(r == 0);

    asm volatile("and %x0, %x1, xzr" : "=r"(r) : "r"(0xFFUL));
    ZASSERT(r == 0);

    asm volatile("mul %x0, %x1, xzr" : "=r"(r) : "r"(0xFFUL));
    ZASSERT(r == 0);

    /* Zero register in flag-setting ops. */
    unsigned long f;
    asm volatile("adds %0, xzr, %2\n\t"
                 "cset %w1, eq"
                 : "=&r"(r), "=r"(f)
                 : "r"(0UL)
                 : "cc");
    ZASSERT(r == 0);
    ZASSERT(f == 1);

    asm volatile("cmp %x1, xzr\n\t"
                 "cset %0, eq"
                 : "=r"(f) : "r"(0UL) : "cc");
    ZASSERT(f == 1);

    asm volatile("cmp %x1, xzr\n\t"
                 "cset %0, ne"
                 : "=r"(f) : "r"(99UL) : "cc");
    ZASSERT(f == 1);

    /* xzr as the discard destination of a csinc-style chain is not used
       here; instead check xzr as a csel source. */
    asm volatile("cmp %w1, #0\n\t"
                 "csel %0, xzr, %1, eq"
                 : "=r"(r) : "r"(77UL) : "cc");
    ZASSERT(r == 77);

    asm volatile("cmp %w1, %w1\n\t"
                 "csel %0, xzr, %1, eq"
                 : "=r"(r) : "r"(0UL) : "cc");
    ZASSERT(r == 0);
    return 0;
}
