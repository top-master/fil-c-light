#include <stdfil.h>

int main(void)
{
    /* Five-instruction chain with a tied destination. */
    unsigned long x = 100;
    unsigned long k = 3;
    unsigned long m = 0xFF0000;
    asm volatile("add %0, %0, #23\n\t"
                 "sub %0, %0, #1\n\t"
                 "mul %0, %0, %1\n\t"
                 "eor %0, %0, %2\n\t"
                 "lsl %0, %0, #2"
                 : "+r"(x)
                 : "r"(k), "r"(m)
                 : "cc");
    {
        unsigned long e = (100 + 23 - 1) * 3;
        e ^= 0xFF0000;
        e <<= 2;
        ZASSERT(x == e);
    }

    /* A block mixing flags, selects, and arithmetic. */
    unsigned long a = 15;
    unsigned long b = 4;
    unsigned long big, small, quo, rem;
    asm volatile("cmp %4, %5\n\t"
                 "csel %0, %4, %5, hs\n\t"
                 "csel %1, %5, %4, hs\n\t"
                 "udiv %2, %4, %5\n\t"
                 "msub %3, %2, %5, %4"
                 : "=&r"(big), "=&r"(small), "=&r"(quo), "=&r"(rem)
                 : "r"(a), "r"(b)
                 : "cc");
    ZASSERT(big == 15);
    ZASSERT(small == 4);
    ZASSERT(quo == 3);
    ZASSERT(rem == 3);

    /* Nine-instruction chain computing a value. */
    unsigned long r = 0;
    asm volatile("movz %0, #0x1234, lsl #0\n\t"
                 "add %0, %0, #0x100\n\t"
                 "sub %0, %0, #0x34\n\t"
                 "lsl %0, %0, #4\n\t"
                 "orr %0, %0, #0xFF\n\t"
                 "eor %0, %0, #0xFF\n\t"
                 "asr %0, %0, #12\n\t"
                 "sub %0, %0, #0x13\n\t"
                 "mvn %0, %0"
                 : "=&r"(r));
    ZASSERT(r == 0xFFFFFFFFFFFFFFFFUL);
    return 0;
}
