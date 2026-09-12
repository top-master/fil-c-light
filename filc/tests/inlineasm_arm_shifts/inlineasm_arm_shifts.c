#include <stdfil.h>

int main(void)
{
    unsigned long r;

    /* Immediate shifts. */
    asm volatile("lsl %0, %1, #7" : "=r"(r) : "r"(0x1234UL));
    ZASSERT(r == 0x1234UL << 7);

    asm volatile("lsr %0, %1, #4" : "=r"(r) : "r"(0x1234UL));
    ZASSERT(r == 0x1234UL >> 4);

    asm volatile("asr %0, %1, #4" : "=r"(r) : "r"((unsigned long)-64L));
    ZASSERT(r == (unsigned long)((-64L) >> 4));

    asm volatile("ror %0, %1, #8" : "=r"(r) : "r"(0xABCD1234UL));
    ZASSERT(r == ((0xABCD1234UL >> 8) | (0xABCD1234UL << 56)));

    /* 32-bit immediate shifts. */
    unsigned int r32;
    asm volatile("lsl %w0, %w1, #3" : "=r"(r32) : "r"(0x1234U));
    ZASSERT(r32 == 0x1234U << 3);

    asm volatile("lsr %w0, %w1, #8" : "=r"(r32) : "r"(0x12345678U));
    ZASSERT(r32 == 0x12345678U >> 8);

    asm volatile("asr %w0, %w1, #8" : "=r"(r32) : "r"(0xFF000000U));
    ZASSERT(r32 == 0xFFFF0000U);

    asm volatile("ror %w0, %w1, #4" : "=r"(r32) : "r"(0x12345678U));
    ZASSERT(r32 == ((0x12345678U >> 4) | (0x12345678U << 28)));

    /* Register shifts (amount taken modulo the register width). */
    unsigned long amt = 5;
    asm volatile("lsl %0, %1, %2" : "=r"(r) : "r"(0xFFUL), "r"(amt));
    ZASSERT(r == 0xFFUL << 5);

    asm volatile("lsr %0, %1, %2" : "=r"(r) : "r"(0xFFUL), "r"(amt));
    ZASSERT(r == 0xFFUL >> 5);

    asm volatile("asr %0, %1, %2" : "=r"(r) : "r"((unsigned long)-128L), "r"(amt));
    ZASSERT(r == (unsigned long)((-128L) >> 5));

    asm volatile("ror %0, %1, %2" : "=r"(r) : "r"(0xF0UL), "r"(4UL));
    ZASSERT(r == (0xF0UL >> 4) | (0xF0UL << 60));

    /* 66 mod 64 == 2. */
    asm volatile("lsl %0, %1, %2" : "=r"(r) : "r"(0xFFUL), "r"(66UL));
    ZASSERT(r == 0xFFUL << 2);

    /* Explicit variable-shift mnemonics. */
    asm volatile("lsrv %0, %1, %2" : "=r"(r) : "r"(0xABCDEFUL), "r"(8UL));
    ZASSERT(r == 0xABCDEFUL >> 8);

    asm volatile("asrv %0, %1, %2" : "=r"(r) : "r"((unsigned long)-1000L), "r"(3UL));
    ZASSERT(r == (unsigned long)((-1000L) >> 3));

    asm volatile("rorv %0, %1, %2" : "=r"(r) : "r"(0xFFUL), "r"(60UL));
    ZASSERT(r == (0xFFUL >> 60) | (0xFFUL << 4));
    return 0;
}
