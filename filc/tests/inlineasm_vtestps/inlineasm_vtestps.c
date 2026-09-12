#include <stdfil.h>

typedef unsigned int v4si __attribute__((vector_size(16)));

int main(void)
{
    /* VTESTPS: Intel order VTESTPS DEST, SRC. AT&T: vtestps SRC, DEST.
       ZF = 1 if all sign bits (31, 63, 95, 127) of (SRC & DEST) are 0.
       CF = 1 if all sign bits of (SRC & ~DEST) are 0.
       DEST is not modified. */

    /* Case 1: sign bits set in both SRC and DEST.
       (SRC & DEST) sign bits set -> ZF = 0.
       (SRC & ~DEST) sign bits clear -> CF = 1. */
    {
        v4si dest = { 0x80000000, 0x80000000, 0x80000000, 0x80000000 };
        v4si src  = { 0x80000000, 0x80000000, 0x80000000, 0x80000000 };
        unsigned char zf, cf;
        asm volatile("vtestps %2, %3\n\t"
                     "setz %0\n\t"
                     "setc %1"
                     : "=&r"(zf), "=&r"(cf)
                     : "x"(src), "x"(dest)
                     : "cc");
        ZASSERT(zf == 0);
        ZASSERT(cf == 1);
        ZASSERT(dest[0] == 0x80000000);
        ZASSERT(dest[3] == 0x80000000);
    }

    /* Case 2: DEST sign bits clear, SRC sign bits set.
       (SRC & DEST) sign bits clear -> ZF = 1.
       (SRC & ~DEST) sign bits set -> CF = 0. */
    {
        v4si dest = { 0, 0, 0, 0 };
        v4si src  = { 0x80000000, 0x80000000, 0x80000000, 0x80000000 };
        unsigned char zf, cf;
        asm volatile("vtestps %2, %3\n\t"
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
