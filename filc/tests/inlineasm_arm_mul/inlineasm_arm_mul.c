#include <stdfil.h>

int main(void)
{
    unsigned long r;

    asm volatile("mul %0, %1, %2" : "=r"(r) : "r"(1234567UL), "r"(7654321UL));
    ZASSERT(r == 1234567UL * 7654321UL);

    unsigned int r32;
    asm volatile("mul %w0, %w1, %w2" : "=r"(r32) : "r"(100000U), "r"(99999U));
    ZASSERT(r32 == 100000U * 99999U);

    /* madd: a * b + c. */
    asm volatile("madd %0, %1, %2, %3" : "=r"(r) : "r"(10UL), "r"(20UL), "r"(3UL));
    ZASSERT(r == 203);

    /* msub: c - a * b. */
    asm volatile("msub %0, %1, %2, %3" : "=r"(r) : "r"(10UL), "r"(20UL), "r"(3UL));
    ZASSERT(r == (unsigned long)-197L);

    /* mneg: -(a * b). */
    asm volatile("mneg %0, %1, %2" : "=r"(r) : "r"(10L), "r"(20L));
    ZASSERT(r == (unsigned long)-200L);

    /* smull/umull: 32x32 -> 64. */
    long sr;
    asm volatile("smull %0, %w1, %w2" : "=r"(sr) : "r"(-123456), "r"(654321));
    ZASSERT(sr == (long)-123456 * 654321);

    unsigned long ur;
    asm volatile("umull %0, %w1, %w2" : "=r"(ur) : "r"(123456U), "r"(654321U));
    ZASSERT(ur == 123456UL * 654321UL);

    /* smulh/umulh: high half of 64x64 -> 128. */
    unsigned long a = 0x123456789ABCDEFUL;
    unsigned long b = 0xFEDCBA987654321UL;
    unsigned long hi, lo;
    asm volatile("umulh %0, %1, %2" : "=r"(hi) : "r"(a), "r"(b));
    asm volatile("mul %0, %1, %2" : "=r"(lo) : "r"(a), "r"(b));
    ZASSERT(((unsigned __int128)a * b) >> 64 == hi);
    ZASSERT((unsigned long)((unsigned __int128)a * b) == lo);

    long sa = (long)0x123456789ABCDEFUL;
    long sb = (long)0xFEDCBA987654321UL;
    asm volatile("smulh %0, %1, %2" : "=r"(hi) : "r"(sa), "r"(sb));
    ZASSERT(((unsigned __int128)((unsigned __int128)(unsigned long)sa * (unsigned long)sb)) >> 64 == hi);

    /* madd chained with mul. */
    asm volatile("mul %1, %2, %3\n\tmadd %0, %2, %2, %1"
                 : "=&r"(r), "=&r"(lo)
                 : "r"(7UL), "r"(6UL));
    ZASSERT(lo == 42);
    ZASSERT(r == 7 * 7 + 42);
    return 0;
}
