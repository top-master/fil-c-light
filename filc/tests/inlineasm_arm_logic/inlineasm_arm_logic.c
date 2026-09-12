#include <stdfil.h>

int main(void)
{
    unsigned long a = 0xF0F0F0F0F0F0F0F0UL;
    unsigned long b = 0x0F0F0F0F0F0F0F0FUL;
    unsigned long o;

    asm volatile("and %0, %1, %2" : "=r"(o) : "r"(a), "r"(b));
    ZASSERT(o == 0);

    asm volatile("orr %0, %1, %2" : "=r"(o) : "r"(a), "r"(b));
    ZASSERT(o == 0xFFFFFFFFFFFFFFFFUL);

    asm volatile("eor %0, %1, %2" : "=r"(o) : "r"(a), "r"(b));
    ZASSERT(o == 0xFFFFFFFFFFFFFFFFUL);

    asm volatile("bic %0, %1, %2" : "=r"(o) : "r"(0xFFUL), "r"(0x0FUL));
    ZASSERT(o == 0xF0);

    asm volatile("orn %0, %1, %2" : "=r"(o) : "r"(0xF0UL), "r"(0x0FUL));
    ZASSERT(o == 0xFFFFFFFFFFFFFFF0UL);

    asm volatile("eon %0, %1, %2" : "=r"(o) : "r"(0xFFUL), "r"(0x0FUL));
    ZASSERT(o == 0xFFFFFFFFFFFFFF0FUL);

    asm volatile("mvn %0, %1" : "=r"(o) : "r"(0xF0F0UL));
    ZASSERT(o == 0xFFFFFFFFFFFF0F0FUL);

    /* 32-bit forms. */
    unsigned int o32;
    asm volatile("and %w0, %w1, %w2" : "=r"(o32) : "r"(0xF0F0F0F0U), "r"(0x0F0F0F0FU));
    ZASSERT(o32 == 0);

    asm volatile("orr %w0, %w1, %w2" : "=r"(o32) : "r"(0xF0F0F0F0U), "r"(0x0F0F0F0FU));
    ZASSERT(o32 == 0xFFFFFFFFU);

    asm volatile("eor %w0, %w1, %w2" : "=r"(o32) : "r"(0xFF00U), "r"(0x0F0FU));
    ZASSERT(o32 == 0xF00FU);

    asm volatile("mvn %w0, %w1" : "=r"(o32) : "r"(0xF0F0U));
    ZASSERT(o32 == 0xFFFF0F0FU);

    /* Immediate forms (bitmask immediates). */
    asm volatile("and %w0, %w1, #0xFF" : "=r"(o32) : "r"(0x1234U));
    ZASSERT(o32 == 0x34);

    asm volatile("orr %w0, %w1, #0xFF00" : "=r"(o32) : "r"(0x1234U));
    ZASSERT(o32 == 0xFF34);

    asm volatile("eor %w0, %w1, #0xF" : "=r"(o32) : "r"(0x1234U));
    ZASSERT(o32 == 0x123B);

    /* Shifted-register operands (trailing lsl modifier). */
    asm volatile("add %0, %1, %2, lsl #4" : "=r"(o) : "r"(2UL), "r"(3UL));
    ZASSERT(o == 50);

    asm volatile("orr %0, %1, %2, lsl #8" : "=r"(o) : "r"(0UL), "r"(0xABUL));
    ZASSERT(o == 0xAB00UL);

    asm volatile("bic %0, %1, %2, lsl #4" : "=r"(o) : "r"(0xFFUL), "r"(0xFUL));
    ZASSERT(o == 0x0FUL);

    asm volatile("and %0, %1, %2, lsl #2" : "=r"(o) : "r"(0xFFFFFFFFUL), "r"(0xFFUL));
    ZASSERT(o == 0x3FCUL);

    /* Flag-setting logic + cset. */
    unsigned long z;
    asm volatile("ands %0, %2, %3\n\t"
                 "cset %w1, eq"
                 : "=&r"(o), "=r"(z)
                 : "r"(0xF0UL), "r"(0x0FUL)
                 : "cc");
    ZASSERT(o == 0);
    ZASSERT(z == 1);

    unsigned long nz;
    asm volatile("bics %0, %2, %3\n\t"
                 "cset %w1, ne"
                 : "=&r"(o), "=r"(nz)
                 : "r"(0xFFUL), "r"(0x0FUL)
                 : "cc");
    ZASSERT(o == 0xF0);
    ZASSERT(nz == 1);
    return 0;
}
