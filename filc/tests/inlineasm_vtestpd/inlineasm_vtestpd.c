#include <stdfil.h>

typedef unsigned long long v2di __attribute__((vector_size(16)));

int main(void)
{
    /* VTESTPD: Intel order VTESTPD DEST, SRC. AT&T: vtestpd SRC, DEST.
       ZF = 1 if all sign bits (63, 127) of (SRC & DEST) are 0.
       CF = 1 if all sign bits of (SRC & ~DEST) are 0.
       DEST is not modified. */

    /* Case 1: sign bits set in both SRC and DEST.
       (SRC & DEST) sign bits set -> ZF = 0.
       (SRC & ~DEST) sign bits clear -> CF = 1. */
    {
        v2di dest = { 0x8000000000000000ULL, 0x8000000000000000ULL };
        v2di src  = { 0x8000000000000000ULL, 0x8000000000000000ULL };
        unsigned char zf, cf;
        asm volatile("vtestpd %2, %3\n\t"
                     "setz %0\n\t"
                     "setc %1"
                     : "=&r"(zf), "=&r"(cf)
                     : "x"(src), "x"(dest)
                     : "cc");
        ZASSERT(zf == 0);
        ZASSERT(cf == 1);
        ZASSERT(dest[0] == 0x8000000000000000ULL);
        ZASSERT(dest[1] == 0x8000000000000000ULL);
    }

    /* Case 2: DEST sign bits clear, SRC sign bits set.
       (SRC & DEST) sign bits clear -> ZF = 1.
       (SRC & ~DEST) sign bits set -> CF = 0. */
    {
        v2di dest = { 0x0ULL, 0x0ULL };
        v2di src  = { 0x8000000000000000ULL, 0x8000000000000000ULL };
        unsigned char zf, cf;
        asm volatile("vtestpd %2, %3\n\t"
                     "setz %0\n\t"
                     "setc %1"
                     : "=&r"(zf), "=&r"(cf)
                     : "x"(src), "x"(dest)
                     : "cc");
        ZASSERT(zf == 1);
        ZASSERT(cf == 0);
    }

    return 0;
}
