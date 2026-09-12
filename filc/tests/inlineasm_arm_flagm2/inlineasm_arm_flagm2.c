#include <stdfil.h>
#include <stdint.h>

/* FEAT_FlagM2 (the Armv8.5-A flag-manipulation instructions) with the
   resulting NZCV materialized into registers via "cset" inside the same asm
   string, checked against C transliterations of the ISA pseudocode
   (axflag.xml; xaflag.xml).

     axflag: z = Z | V; c = C & !V;
             PSTATE.[N,Z,C,V] = '0' :: z :: c :: '0'
             (turns the flags into "last comparison was unsigned-ordered"
             form: C set means "unordered-or-greater" style ACFLAG)
     xaflag: n = !C & !Z; z = Z & C; c = C | Z; v = !C & Z
             (the inverse transformation of axflag)

   setf32/setf64 are not part of the 2026-06 ISA XML and are not accepted by
   the assembler, so the FEAT_FlagM2 surface testable here is axflag and
   xaflag (both -march gated via armv8.5-a, which implies FlagM2). Initial
   flag states are produced by cmp/cmn of explicit operands inside the asm
   and modeled in C as for the subs/adds forms. Both instructions set NZCV,
   so every asm block carries a "cc" clobber. */

struct flags { int n, z, c, v; };

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

static uint32_t seed = 0xf1a92d0eu;
static uint32_t rnd(void)
{
    seed = seed * 1103515245u + 12345u;
    return seed >> 8;
}

int main(void)
{
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

        /* axflag from both cmp and cmn initial states. */
        for (int it = 0; it < 2; ++it) {
            struct flags f0 = (it == 0) ? cmp_model(a, b) : cmn_model(a, b);
            struct flags want;
            want.n = 0;
            want.z = f0.z || f0.v;
            want.c = f0.c && !f0.v;
            want.v = 0;
            unsigned nn, zz, cc, vv;
            const char *setup = (it == 0) ? "cmp" : "cmn";
            if (it == 0) {
                asm volatile("cmp %4, %5\n\taxflag\n\t"
                             "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                             : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                             : "r"(a), "r"(b) : "cc");
            } else {
                asm volatile("cmn %4, %5\n\taxflag\n\t"
                             "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                             : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                             : "r"(a), "r"(b) : "cc");
            }
            ZASSERT(nn == (unsigned)want.n);
            ZASSERT(zz == (unsigned)want.z);
            ZASSERT(cc == (unsigned)want.c);
            ZASSERT(vv == (unsigned)want.v);
            (void)setup;
        }

        /* xaflag from both cmp and cmn initial states. */
        for (int it = 0; it < 2; ++it) {
            struct flags f0 = (it == 0) ? cmp_model(a, b) : cmn_model(a, b);
            struct flags want;
            want.n = !f0.c && !f0.z;
            want.z = f0.z && f0.c;
            want.c = f0.c || f0.z;
            want.v = !f0.c && f0.z;
            unsigned nn, zz, cc, vv;
            if (it == 0) {
                asm volatile("cmp %4, %5\n\txaflag\n\t"
                             "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                             : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                             : "r"(a), "r"(b) : "cc");
            } else {
                asm volatile("cmn %4, %5\n\txaflag\n\t"
                             "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                             : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                             : "r"(a), "r"(b) : "cc");
            }
            ZASSERT(nn == (unsigned)want.n);
            ZASSERT(zz == (unsigned)want.z);
            ZASSERT(cc == (unsigned)want.c);
            ZASSERT(vv == (unsigned)want.v);
        }

        /* axflag followed by xaflag restores a "canonical" state: axflag
           zeroes N and V, so xaflag(axflag(x)) keeps C/Z per the axflag
           result. Check the round-trip identity on the modeled flags. */
        {
            struct flags f0 = cmp_model(a, b);
            struct flags f1;
            f1.n = 0;
            f1.z = f0.z || f0.v;
            f1.c = f0.c && !f0.v;
            f1.v = 0;
            struct flags f2;
            f2.n = !f1.c && !f1.z;
            f2.z = f1.z && f1.c;
            f2.c = f1.c || f1.z;
            f2.v = !f1.c && f1.z;
            unsigned nn, zz, cc, vv;
            asm volatile("cmp %4, %5\n\taxflag\n\txaflag\n\t"
                         "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                         : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                         : "r"(a), "r"(b) : "cc");
            ZASSERT(nn == (unsigned)f2.n);
            ZASSERT(zz == (unsigned)f2.z);
            ZASSERT(cc == (unsigned)f2.c);
            ZASSERT(vv == (unsigned)f2.v);
        }
    }

    /* Named cases: axflag after "unordered" (V=1) and ordered comparisons. */
    {
        unsigned nn, zz, cc, vv;
        /* cmp of INT64_MIN and 1 overflows -> V=1, C=1; axflag must yield
           N=0, Z=Z|V=1, C=C&!V=0, V=0. */
        asm volatile("cmp %4, %5\n\taxflag\n\t"
                     "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                     : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                     : "r"(0x8000000000000000UL), "r"(1UL) : "cc");
        ZASSERT(nn == 0 && zz == 1 && cc == 0 && vv == 0);

        /* equal operands: Z=1, C=1, V=0 -> axflag: N=0, Z=1, C=1, V=0. */
        asm volatile("cmp %4, %5\n\taxflag\n\t"
                     "cset %w0, mi\n\tcset %w1, eq\n\tcset %w2, cs\n\tcset %w3, vs"
                     : "=&r"(nn), "=&r"(zz), "=&r"(cc), "=&r"(vv)
                     : "r"(7UL), "r"(7UL) : "cc");
        ZASSERT(nn == 0 && zz == 1 && cc == 1 && vv == 0);
    }

    return 0;
}
