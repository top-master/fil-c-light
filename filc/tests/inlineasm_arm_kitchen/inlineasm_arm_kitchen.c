#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    /* Kitchen sink: an integer/flags block... */
    unsigned long v = 0x1234;
    unsigned long w = 0x5678;
    unsigned long sum, packed, sel, quo, clzn, hi;
    asm volatile("add %0, %6, %7\n\t"
                 "movz %1, #0x1234, lsl #0\n\t"
                 "movk %1, #0xBEEF, lsl #16\n\t"
                 "add %1, %1, #1\n\t"
                 "cmp %6, %7\n\t"
                 "csel %2, %6, %7, lo\n\t"
                 "udiv %3, %0, %7\n\t"
                 "clz %4, %6\n\t"
                 "umulh %5, %6, %7\n\t"
                 "add %0, %0, #0\n\t"
                 : "=&r"(sum), "=&r"(packed), "=&r"(sel), "=&r"(quo), "=&r"(clzn), "=&r"(hi)
                 : "r"(v), "r"(w)
                 : "cc");
    ZASSERT(sum == 0x1234UL + 0x5678UL);
    ZASSERT(packed == ((0xBEEFUL << 16) | 0x1234) + 1);
    ZASSERT(sel == 0x1234UL);
    ZASSERT(quo == (0x1234UL + 0x5678UL) / 0x5678UL);
    ZASSERT(clzn == (unsigned long)__builtin_clzl(0x1234));
    ZASSERT(hi == ((unsigned __int128)0x1234UL * 0x5678UL) >> 64);

    /* ...a scalar FP block... */
    double fa = 3.5, fb = 2.0, fc = 1.0, fr;
    long fi;
    asm volatile("fmul %d0, %d2, %d3\n\t"
                 "fmadd %d0, %d0, %d2, %d4\n\t"
                 "fcvtzs %x1, %d0\n\t"
                 "fdiv %d0, %d0, %d2\n\t"
                 "frintm %d0, %d0"
                 : "=&w"(fr), "=&r"(fi)
                 : "w"(fa), "w"(fb), "w"(fc));
    ZASSERT(fr == 7.0);
    ZASSERT(fi == 25);

    /* ...and a NEON block, all in one program. */
    int32x4_t na = {1, 2, 3, 4};
    int32x4_t nb = {10, 20, 30, 40};
    int32x4_t nr;
    int lane, total, lane0;
    asm volatile("add %0.4s, %4.4s, %5.4s\n\t"
                 "shl %0.4s, %0.4s, #1\n\t"
                 "umov %w1, %0.s[3]\n\t"
                 "addv %s2, %0.4s\n\t"
                 "ins %0.s[0], wzr\n\t"
                 "mul %0.4s, %0.4s, %4.4s\n\t"
                 "umov %w3, %0.s[0]"
                 : "=&w"(nr), "=&r"(lane), "=&w"(total), "=&r"(lane0)
                 : "w"(na), "w"(nb));
    ZASSERT(lane == 88);
    ZASSERT(total == 220);
    ZASSERT(lane0 == 0);

    return 0;
}
