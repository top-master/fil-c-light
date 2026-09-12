#include <stdfil.h>

int main(void)
{
    long q;

    asm volatile("sdiv %0, %1, %2" : "=r"(q) : "r"(100L), "r"(7L));
    ZASSERT(q == 14);

    asm volatile("sdiv %0, %1, %2" : "=r"(q) : "r"(-100L), "r"(7L));
    ZASSERT(q == -14);

    asm volatile("sdiv %0, %1, %2" : "=r"(q) : "r"(100L), "r"(-7L));
    ZASSERT(q == -14);

    asm volatile("sdiv %0, %1, %2" : "=r"(q) : "r"(-100L), "r"(-7L));
    ZASSERT(q == 14);

    unsigned long uq;
    asm volatile("udiv %0, %1, %2" : "=r"(uq) : "r"(100UL), "r"(7UL));
    ZASSERT(uq == 14);

    unsigned int q32;
    asm volatile("sdiv %w0, %w1, %w2" : "=r"(q32) : "r"(1000), "r"(32));
    ZASSERT(q32 == 31);

    /* Division by zero yields zero, no trap. */
    asm volatile("sdiv %0, %1, %2" : "=r"(q) : "r"(42L), "r"(0L));
    ZASSERT(q == 0);

    asm volatile("udiv %0, %1, %2" : "=r"(uq) : "r"(42UL), "r"(0UL));
    ZASSERT(uq == 0);

    /* INT_MIN / -1 stays INT_MIN, no trap. */
    asm volatile("sdiv %w0, %w1, %w2" : "=r"(q32) : "r"((-2147483647 - 1)), "r"(-1));
    ZASSERT(q32 == 0x80000000U);

    long big = (long)0x8000000000000000UL;
    asm volatile("sdiv %0, %1, %2" : "=r"(q) : "r"(big), "r"(-1L));
    ZASSERT(q == (long)0x8000000000000000UL);
    return 0;
}
