#include <stdfil.h>

int main(void)
{
    unsigned long sum;
    unsigned long carry;

    /* 64-bit adds with carry-out checked via cset. */
    asm volatile("adds %0, %2, %3\n\t"
                 "cset %1, hs"
                 : "=&r"(sum), "=r"(carry)
                 : "r"(10UL), "r"(5UL)
                 : "cc");
    ZASSERT(sum == 15);
    ZASSERT(carry == 0);

    asm volatile("adds %0, %2, %3\n\t"
                 "cset %1, hs"
                 : "=&r"(sum), "=r"(carry)
                 : "r"(0xFFFFFFFFFFFFFFFFUL), "r"(1UL)
                 : "cc");
    ZASSERT(sum == 0);
    ZASSERT(carry == 1);

    asm volatile("adds %0, %2, %3\n\t"
                 "cset %1, hs"
                 : "=&r"(sum), "=r"(carry)
                 : "r"(0x8000000000000000UL), "r"(0x8000000000000000UL)
                 : "cc");
    ZASSERT(sum == 0);
    ZASSERT(carry == 1);

    /* Signed overflow (vs). */
    unsigned long of;
    asm volatile("adds %0, %2, %3\n\t"
                 "cset %1, vs"
                 : "=&r"(sum), "=r"(of)
                 : "r"(0x7FFFFFFFFFFFFFFFUL), "r"(1UL)
                 : "cc");
    ZASSERT(sum == 0x8000000000000000UL);
    ZASSERT(of == 1);

    /* Zero result also sets Z. */
    unsigned long zero;
    asm volatile("adds %0, %2, %3\n\t"
                 "cset %1, eq"
                 : "=&r"(sum), "=r"(zero)
                 : "r"(0x8000000000000000UL), "r"(0x8000000000000000UL)
                 : "cc");
    ZASSERT(sum == 0);
    ZASSERT(zero == 1);

    /* 32-bit adds. */
    unsigned int s32;
    unsigned int c32;
    asm volatile("adds %w0, %w2, %w3\n\t"
                 "cset %w1, hs"
                 : "=&r"(s32), "=r"(c32)
                 : "r"(0xFFFFFFFFU), "r"(2U)
                 : "cc");
    ZASSERT(s32 == 1);
    ZASSERT(c32 == 1);

    /* csel consuming the flags from adds. */
    unsigned long val = 0xFFFFFFFFFFFFFFFFUL;
    unsigned long pick;
    unsigned long newsum;
    asm volatile("adds %1, %2, #1\n\t"
                 "csel %0, %2, xzr, hs"
                 : "=r"(pick), "=&r"(newsum)
                 : "r"(val)
                 : "cc");
    ZASSERT(newsum == 0);
    ZASSERT(pick == val);
    return 0;
}
