#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* Literal immediate operands in several instructions. */
    asm volatile("add %0, %1, #42" : "=r"(r) : "r"(0UL));
    ZASSERT(r == 42);

    asm volatile("add %0, %1, #0x1000" : "=r"(r) : "r"(1UL));
    ZASSERT(r == 0x1001);

    asm volatile("sub %0, %1, #1" : "=r"(r) : "r"(1000UL));
    ZASSERT(r == 999);

    asm volatile("and %w0, %w1, #0xFF" : "=r"(r) : "r"(0x12345678UL));
    ZASSERT(r == 0x78);

    asm volatile("orr %w0, %w1, #0xFF0000" : "=r"(r) : "r"(0x12UL));
    ZASSERT(r == 0xFF0012);

    asm volatile("eor %w0, %w1, #0x0F0F0F0F" : "=r"(r) : "r"(0x0F0F0F0FUL));
    ZASSERT(r == 0);

    asm volatile("movz %0, #0xBEEF, lsl #16" : "=r"(r));
    ZASSERT(r == 0xBEEF0000UL);

    asm volatile("movz %0, #0x1234, lsl #16\n\tmovk %0, #0x5678, lsl #0" : "=r"(r));
    ZASSERT(r == 0x12345678UL);

    asm volatile("lsl %0, %1, #5" : "=r"(r) : "r"(3UL));
    ZASSERT(r == 96);

    asm volatile("extr %0, %1, %2, #12" : "=r"(r) : "r"(0xFFUL), "r"(0xEEUL));
    ZASSERT(r == ((0xFFUL << 52) | (0xEEUL >> 12)));

    /* Conditions and barrier options are immediate-like. */
    unsigned long f;
    asm volatile("cmp %w1, #10\n\tcset %0, eq" : "=r"(f) : "r"(10UL) : "cc");
    ZASSERT(f == 1);

    asm volatile("dmb ish" ::: "memory");

    /* Unused "i" and "n" operands are allowed. */
    unsigned long u = 3;
    asm volatile("add %0, %1, #5" : "=r"(r) : "r"(u), "i"(7));
    ZASSERT(r == 8);

    asm volatile("add %0, %1, #2" : "=r"(r) : "r"(u), "n"(9));
    ZASSERT(r == 5);

    /* Immediates used as shift amounts in modifiers. */
    asm volatile("add %0, %1, %2, lsl #3" : "=r"(r) : "r"(1UL), "r"(1UL));
    ZASSERT(r == 9);

    asm volatile("orr %0, %1, %2, lsl #12" : "=r"(r) : "r"(0UL), "r"(0xFFUL));
    ZASSERT(r == 0xFF000UL);
    return 0;
}
