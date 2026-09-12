#include <stdfil.h>

int main(void)
{
    unsigned long r;
    unsigned int r32;

    /* rev: full byteswap. */
    asm volatile("rev %0, %1" : "=r"(r) : "r"(0x0123456789ABCDEFUL));
    ZASSERT(r == 0xEFCDAB8967452301UL);

    asm volatile("rev %w0, %w1" : "=r"(r32) : "r"(0x01234567U));
    ZASSERT(r32 == 0x67452301U);

    /* rev16: swap bytes in each halfword. */
    asm volatile("rev16 %x0, %x1" : "=r"(r) : "r"(0x1122334455667788UL));
    ZASSERT(r == 0x2211443366558877UL);

    asm volatile("rev16 %w0, %w1" : "=r"(r32) : "r"(0x11223344U));
    ZASSERT(r32 == 0x22114433U);

    /* rev32: swap bytes in each word (64-bit only). */
    asm volatile("rev32 %x0, %x1" : "=r"(r) : "r"(0x1122334455667788UL));
    ZASSERT(r == 0x4433221188776655UL);

    /* Vector rev64: reverse the order of bytes in each 64-bit half. */
    unsigned long vin = 0x0001020304050607UL;
    unsigned long vout;
    asm volatile("rev64 %0.8b, %1.8b" : "=w"(vout) : "w"(vin));
    ZASSERT(vout == 0x0706050403020100UL);

    /* clz/cls. */
    asm volatile("clz %0, %1" : "=r"(r) : "r"(1UL));
    ZASSERT(r == 63);

    asm volatile("clz %x0, %x1" : "=r"(r) : "r"(0x00FF000000000000UL));
    ZASSERT(r == 8);

    asm volatile("clz %w0, %w1" : "=r"(r32) : "r"(1U));
    ZASSERT(r32 == 31);

    asm volatile("cls %w0, %w1" : "=r"(r32) : "r"(1U));
    ZASSERT(r32 == 30);

    asm volatile("cls %w0, %w1" : "=r"(r32) : "r"(0xFFFF0000U));
    ZASSERT(r32 == 15);

    long sv2 = -256;
    asm volatile("cls %x0, %x1" : "=r"(r) : "r"((unsigned long)sv2));
    ZASSERT(r == 55);

    /* rbit: reverse all bits. */
    unsigned long rb = 0;
    unsigned long vin2 = 0xF0F0F0F000000001UL;
    asm volatile("rbit %0, %1" : "=r"(rb) : "r"(vin2));
    {
        unsigned long e = 0;
        for (int i = 0; i < 64; ++i)
            if (vin2 & (1UL << i))
                e |= 1UL << (63 - i);
        ZASSERT(rb == e);
    }

    unsigned int rb32;
    unsigned int vin32 = 0x80000001U;
    asm volatile("rbit %w0, %w1" : "=r"(rb32) : "r"(vin32));
    ZASSERT(rb32 == 0x80000001U);
    return 0;
}
