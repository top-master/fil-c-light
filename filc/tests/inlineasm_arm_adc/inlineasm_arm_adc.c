#include <stdfil.h>

int main(void)
{
    /* 128-bit add via adds/adc, checked against unsigned __int128. */
    unsigned long alo = 0xFEDCBA9876543210UL, ahi = 0x0123456789ABCDEFUL;
    unsigned long blo = 0x1234567890ABCDEFUL, bhi = 0x0FEDCBA987654321UL;
    unsigned long rlo, rhi;
    asm volatile("adds %0, %2, %3\n\t"
                 "adc %1, %4, %5"
                 : "=&r"(rlo), "=r"(rhi)
                 : "r"(alo), "r"(blo), "r"(ahi), "r"(bhi)
                 : "cc");
    unsigned __int128 expect = (((unsigned __int128)ahi) << 64 | alo) +
                               (((unsigned __int128)bhi) << 64 | blo);
    ZASSERT(((unsigned __int128)rhi << 64 | rlo) == expect);

    /* Carry into adc must come from the adds. */
    alo = 0xFFFFFFFFFFFFFFFFUL;
    blo = 1;
    ahi = 100;
    bhi = 200;
    asm volatile("adds %0, %2, %3\n\t"
                 "adc %1, %4, %5"
                 : "=&r"(rlo), "=r"(rhi)
                 : "r"(alo), "r"(blo), "r"(ahi), "r"(bhi)
                 : "cc");
    ZASSERT(rlo == 0);
    ZASSERT(rhi == 301);

    /* 128-bit subtract via subs/sbc. */
    alo = 0x0000000000000001UL;
    ahi = 500;
    blo = 0x0000000000000002UL;
    bhi = 100;
    asm volatile("subs %0, %2, %3\n\t"
                 "sbc %1, %4, %5"
                 : "=&r"(rlo), "=r"(rhi)
                 : "r"(alo), "r"(blo), "r"(ahi), "r"(bhi)
                 : "cc");
    expect = (((unsigned __int128)ahi) << 64 | alo) -
             (((unsigned __int128)bhi) << 64 | blo);
    ZASSERT(((unsigned __int128)rhi << 64 | rlo) == expect);

    /* adcs/sbcs with carry/borrow out. */
    unsigned long c;
    asm volatile("adds %2, %3, %4\n\t"
                 "adcs %0, %5, %6\n\t"
                 "cset %w1, hs"
                 : "=&r"(rhi), "=r"(c), "=&r"(rlo)
                 : "r"(0xFFFFFFFFFFFFFFFFUL), "r"(1UL), "r"(0UL), "r"(0UL)
                 : "cc");
    ZASSERT(rlo == 0); /* 0xffff...f + 1 wraps to zero */
    ZASSERT(rhi == 1); /* the carry from adds flows into adcs */
    ZASSERT(c == 0); /* and produces no carry out */

    /* ngc: dest = 0 - src - borrow(borrow = !C). */
    unsigned long v = 42;
    unsigned long r;
    asm volatile("cmp %1, %2\n\t"
                 "ngc %0, %3"
                 : "=r"(r) : "r"(1UL), "r"(2UL), "r"(v) : "cc");
    /* 1 < 2 borrows, so C clear, so ngc computes 0 - 42 - 1 = ~42. */
    ZASSERT(r == ~42UL);

    asm volatile("cmp %1, %2\n\t"
                 "ngc %0, %3"
                 : "=r"(r) : "r"(2UL), "r"(1UL), "r"(v) : "cc");
    /* No borrow, C set, so ngc computes 0 - 42 = -42. */
    ZASSERT(r == 0xFFFFFFFFFFFFFFD6UL);

    /* ngcs with sign out. */
    asm volatile("cmp %2, %3\n\t"
                 "ngcs %0, %4\n\t"
                 "cset %w1, mi"
                 : "=&r"(r), "=r"(c)
                 : "r"(1UL), "r"(2UL), "r"(v)
                 : "cc");
    ZASSERT(r == ~42UL);
    ZASSERT(c == 1);
    return 0;
}
