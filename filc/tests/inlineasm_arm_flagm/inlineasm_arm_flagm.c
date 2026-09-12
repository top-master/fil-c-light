#include <stdfil.h>
#include <stdint.h>

/* FEAT_FlagM (Armv8.4-A) flag manipulation instructions, with the resulting
   NZCV materialized into registers via "cset" inside the same asm string,
   checked against C transliterations of the ISA pseudocode (cfinv/rmif/
   setf.xml).

     cfinv:            PSTATE.C = !PSTATE.C
     rmif Xn, #shift, #mask:
         flags = (Xn::Xn)[shift+3:shift]   (4 bits, 3 = N .. 0 = V)
         if mask[3]: PSTATE.N = flags[3]
         if mask[2]: PSTATE.Z = flags[2]
         if mask[1]: PSTATE.C = flags[1]
         if mask[0]: PSTATE.V = flags[0]
       i.e. flag bit j comes from Xn bit (shift + j) mod 64.
     setf8 Wn:  PSTATE.N = Wn[7]; PSTATE.Z = (Wn[7:0] == 0);
                PSTATE.V = Wn[8] ^ Wn[7]; C unchanged
     setf16 Wn: PSTATE.N = Wn[15]; PSTATE.Z = (Wn[15:0] == 0);
                PSTATE.V = Wn[16] ^ Wn[15]; C unchanged

   Initial flag states are produced by cmp/cmn of explicit operands inside
   the asm; their architectural values are modeled in C
   (subs: N = res63, Z = res==0, C = no borrow, V = signed overflow;
    adds: C = unsigned carry-out, V = signed overflow). All of these
   instructions set NZCV, so every asm block carries a "cc" clobber. */

struct flags { int n, z, c, v; };

/* Model of "cmp a, b" (subs with discarded result). */
static struct flags cmp_model(unsigned long a, unsigned long b)
{
    unsigned long res = a - b;
    struct flags f;
    f.n = (int)(res >> 63);
    f.z = (res == 0);
    f.c = (a >= b);
    f.v = (int)(((a ^ b) & (a ^ res)) >> 63);
    return f;
}

/* Model of "cmn a, b" (adds with discarded result). */
static struct flags cmn_model(unsigned long a, unsigned long b)
{
    unsigned long res = a + b;
    struct flags f;
    f.n = (int)(res >> 63);
    f.z = (res == 0);
    f.c = (res < a);
    f.v = (int)((~(a ^ b) & (a ^ res)) >> 63);
    return f;
}

#define RMIF_CASE(SH, MK) \
    do { \
        unsigned nn, zz, cc, vv; \
        asm volatile("cmp %5, %6\n\trmif %4, #" #SH ", #" #MK "\n\t" \
                     "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs" \
                     : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv) \
                     : "r"(reg), "r"(a), "r"(b) \
                     : "cc"); \
        struct flags want = f0; \
        if ((MK >> 3) & 1) want.n = (int)((reg >> ((SH + 3) & 63)) & 1); \
        if ((MK >> 2) & 1) want.z = (int)((reg >> ((SH + 2) & 63)) & 1); \
        if ((MK >> 1) & 1) want.c = (int)((reg >> ((SH + 1) & 63)) & 1); \
        if (MK & 1)        want.v = (int)((reg >> (SH & 63)) & 1); \
        ZASSERT(nn == (unsigned)want.n); \
        ZASSERT(zz == (unsigned)want.z); \
        ZASSERT(cc == (unsigned)want.c); \
        ZASSERT(vv == (unsigned)want.v); \
    } while (0)

static uint32_t seed = 0xfa9cbe17u;
static uint32_t rnd(void)
{
    seed = seed * 1103515245u + 12345u;
    return seed >> 8;
}

int main(void)
{
    /* Initial states via cmp/cmn of pairs chosen to cover N/Z/C/V
       combinations (including signed-overflow V=1 cases). */
    unsigned long pairs[][2] = {
        { 2, 1 }, { 0, 1 }, { 5, 5 }, { 0, 0 },
        { 0x8000000000000000UL, 0x8000000000000000UL },
        { 0x7fffffffffffffffUL, 1 },
        { 0xffffffffffffffffUL, 0xffffffffffffffffUL },
        { 0xc000000000000000UL, 0xc000000000000000UL },
        { 0x123456789abcdef0UL, 0x0fedcba987654321UL },
        { 0x7fffffffffffffffUL, 0xffffffffffffffffUL },
        { 0x8000000000000000UL, 1 },
    };
    int npairs = (int)(sizeof(pairs) / sizeof(pairs[0]));

    for (int i = 0; i < npairs; ++i) {
        unsigned long a = pairs[i][0], b = pairs[i][1];

        /* cfinv: C = !C, checked in both directions. */
        {
            struct flags f = cmp_model(a, b);
            unsigned c_hw;
            asm volatile("cmp %1, %2\n\tcfinv\n\tcset %w0, cs"
                         : "=&r"(c_hw) : "r"(a), "r"(b) : "cc");
            ZASSERT(c_hw == (unsigned)!f.c);

            f = cmp_model(b, a);
            asm volatile("cmp %1, %2\n\tcfinv\n\tcset %w0, cs"
                         : "=&r"(c_hw) : "r"(b), "r"(a) : "cc");
            ZASSERT(c_hw == (unsigned)!f.c);

            /* double inversion restores the original C */
            f = cmn_model(a, b);
            unsigned c_hw2;
            asm volatile("cmn %1, %2\n\tcfinv\n\tcfinv\n\tcset %w0, cs"
                         : "=&r"(c_hw2) : "r"(a), "r"(b) : "cc");
            ZASSERT(c_hw2 == (unsigned)f.c);
        }

        /* rmif: grid of shift/mask immediates (the immediates must be
           literal template text), with a fresh 64-bit source each time. */
        for (int it = 0; it < 2; ++it) {
            struct flags f0 = cmp_model(a, b);
            unsigned long reg = (unsigned long)rnd() << 32 | rnd();
            RMIF_CASE(0, 0);  RMIF_CASE(0, 15); RMIF_CASE(0, 1);  RMIF_CASE(0, 8);
            RMIF_CASE(1, 0);  RMIF_CASE(1, 5);  RMIF_CASE(1, 7);  RMIF_CASE(1, 9);
            RMIF_CASE(7, 3);  RMIF_CASE(7, 12); RMIF_CASE(7, 15); RMIF_CASE(7, 1);
            RMIF_CASE(13, 6); RMIF_CASE(13, 9); RMIF_CASE(13, 15);
            RMIF_CASE(31, 15); RMIF_CASE(31, 2);
            RMIF_CASE(32, 15); RMIF_CASE(32, 4);
            RMIF_CASE(60, 15); RMIF_CASE(61, 15); RMIF_CASE(62, 15); RMIF_CASE(63, 15);
            RMIF_CASE(62, 8); RMIF_CASE(63, 3);
        }

        /* setf8: N = reg[7], Z = (reg[7:0] == 0), V = reg[8] ^ reg[7],
           C unchanged. */
        for (int it = 0; it < 100; ++it) {
            unsigned reg32 = rnd();
            struct flags f0 = cmp_model(a, b);
            struct flags want = f0;
            want.n = (int)((reg32 >> 7) & 1);
            want.z = ((reg32 & 0xffu) == 0);
            want.v = (int)(((reg32 >> 8) & 1) ^ want.n);
            unsigned nn, zz, cc, vv;
            asm volatile("cmp %5, %6\n\tsetf8 %w4\n\t"
                         "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                         : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                         : "r"(reg32), "r"(a), "r"(b)
                         : "cc");
            ZASSERT(nn == (unsigned)want.n);
            ZASSERT(zz == (unsigned)want.z);
            ZASSERT(cc == (unsigned)f0.c); /* C is unchanged by setf8 */
            ZASSERT(vv == (unsigned)want.v);
        }

        /* setf16: N = reg[15], Z = (reg[15:0] == 0), V = reg[16] ^ reg[15],
           C unchanged. */
        for (int it = 0; it < 100; ++it) {
            unsigned reg32 = rnd();
            struct flags f0 = cmn_model(a, b);
            struct flags want = f0;
            want.n = (int)((reg32 >> 15) & 1);
            want.z = ((reg32 & 0xffffu) == 0);
            want.v = (int)(((reg32 >> 16) & 1) ^ want.n);
            unsigned nn, zz, cc, vv;
            asm volatile("cmn %5, %6\n\tsetf16 %w4\n\t"
                         "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                         : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                         : "r"(reg32), "r"(a), "r"(b)
                         : "cc");
            ZASSERT(nn == (unsigned)want.n);
            ZASSERT(zz == (unsigned)want.z);
            ZASSERT(cc == (unsigned)f0.c); /* C is unchanged by setf16 */
            ZASSERT(vv == (unsigned)want.v);
        }
    }

    /* Targeted setf8/setf16 corner cases (initial C comes from an
       "adds"-style carry, i.e. cmn of two nonneg values keeps C=0). */
    {
        unsigned reg32 = 0x000000ffu; /* low byte 0xff -> N=1, Z=0, V=0^1=1 */
        unsigned nn, zz, cc, vv;
        asm volatile("cmn %4, %5\n\tsetf8 %w4\n\t"
                     "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                     : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                     : "r"(reg32), "r"(1UL)
                     : "cc");
        ZASSERT(nn == 1 && zz == 0 && cc == 0 && vv == 1);
    }
    {
        unsigned reg32 = 0x00010000u; /* low byte 0 -> N=0, Z=1, V=0^0=0 */
        unsigned nn, zz, cc, vv;
        asm volatile("cmn %4, %5\n\tsetf8 %w4\n\t"
                     "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                     : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                     : "r"(reg32), "r"(1UL)
                     : "cc");
        ZASSERT(nn == 0 && zz == 1 && cc == 0 && vv == 0);
    }
    {
        unsigned reg32 = 0x0001ffffu; /* low 16 bits 0xffff, bit16=1 ->
                                         N=1, Z=0, V=1^1=0 */
        unsigned nn, zz, cc, vv;
        asm volatile("cmn %4, %5\n\tsetf16 %w4\n\t"
                     "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                     : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                     : "r"(reg32), "r"(1UL)
                     : "cc");
        ZASSERT(nn == 1 && zz == 0 && cc == 0 && vv == 0);
    }

    return 0;
}
