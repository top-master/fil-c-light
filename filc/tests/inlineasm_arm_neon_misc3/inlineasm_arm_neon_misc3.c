#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>

/* Exact C transliteration of the ARM architecture pseudocode for the
   reciprocal estimates, so the hardware results can be checked against
   something independent of the assembler/intrinsic path.

   RecipEstimate() (increasedprecision == FALSE):
       a in 256..511; b = 2^19 / (a*2+1); r = (b+1)/2;  r in 256..511.
   UnsignedRecipEstimate{32}(x):
       x < 0x80000000 -> 0xFFFFFFFF; else RecipEstimate(x[31:23]) << 23.
   RecipSqrtEstimate() (increasedprecision == FALSE):
       a in 128..511; if a < 256 then a = a*2+1 else a = ((a>>1)<<1 + 1)*2;
       b = 512; while a*(b+1)^2 < 2^28: b++;  r = (b+1)/2;  r in 256..511.
   UnsignedRSqrtEstimate{32}(x):
       x[31:30] == 0 -> 0xFFFFFFFF; else RecipSqrtEstimate(x[31:23]) << 23. */
static uint32_t recip_estimate(uint32_t a)
{
    uint32_t aa = a * 2u + 1u;
    uint32_t b = (1u << 19) / aa;
    return (b + 1u) / 2u;
}

static uint32_t urecpe_ref(uint32_t x)
{
    if (!(x & 0x80000000u))
        return 0xFFFFFFFFu;
    return recip_estimate(x >> 23) << 23;
}

static uint32_t ursqrte_ref(uint32_t x)
{
    uint32_t a, b;
    if (!(x & 0xC0000000u))
        return 0xFFFFFFFFu;
    a = x >> 23; /* 128..511 */
    if (a < 256u)
        a = a * 2u + 1u;
    else {
        a = (a >> 1) << 1;
        a = (a + 1u) * 2u;
    }
    b = 512u;
    while (a * (b + 1u) * (b + 1u) < (1u << 28))
        ++b;
    return ((b + 1u) / 2u) << 23;
}

/* Carry-less (polynomial) multiply of two bytes, per PolynomialMult. */
static uint8_t pmul8(uint8_t a, uint8_t b)
{
    uint8_t r = 0;
    for (int i = 0; i < 8; ++i)
        if ((a >> i) & 1)
            r ^= (uint8_t)(b << i);
    return r;
}

int main(void)
{
    /* sabd: signed absolute difference, .4s. */
    int32x4_t a = {100, -100, 7, INT32_MIN + 1};
    int32x4_t b = {23, 23, -7, 0};
    int32x4_t c;
    asm volatile("sabd %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 77);
    ZASSERT(c[1] == 123);
    ZASSERT(c[2] == 14);
    ZASSERT(c[3] == INT32_MAX); /* |INT32_MIN+1| saturates via abs */

    /* uabd: unsigned absolute difference, .8h. */
    uint16x8_t ua = {0xFFFF, 10, 300, 0, 1000, 2000, 1, 2};
    uint16x8_t ub = {1, 20, 100, 5, 1000, 1000, 9, 7};
    uint16x8_t uc;
    asm volatile("uabd %0.8h, %1.8h, %2.8h" : "=w"(uc) : "w"(ua), "w"(ub));
    ZASSERT(uc[0] == 65534);
    ZASSERT(uc[1] == 10);
    ZASSERT(uc[2] == 200);
    ZASSERT(uc[3] == 5);
    ZASSERT(uc[4] == 0 && uc[6] == 8 && uc[7] == 5);

    /* sabdl: widening signed absolute difference, .8h <- .8b. */
    int8x8_t wa = {-128, 127, -5, 5, 0, 100, -100, 3};
    int8x8_t wb = {127, -128, 5, -5, 1, 0, 100, -3};
    int16x8_t wc;
    asm volatile("sabdl %0.8h, %1.8b, %2.8b" : "=w"(wc) : "w"(wa), "w"(wb));
    ZASSERT(wc[0] == 255);
    ZASSERT(wc[1] == 255);
    ZASSERT(wc[2] == 10);
    ZASSERT(wc[3] == 10);
    ZASSERT(wc[4] == 1 && wc[5] == 100 && wc[6] == 200 && wc[7] == 6);

    /* uabdl2: widening unsigned absolute difference of the high halves,
       .4s <- .8h. */
    uint16x8_t w2a = {0, 0, 0, 0, 60000, 1000, 5, 7};
    uint16x8_t w2b = {0, 0, 0, 0, 50000, 3000, 7, 5};
    uint32x4_t w2c;
    asm volatile("uabdl2 %0.4s, %1.8h, %2.8h" : "=w"(w2c) : "w"(w2a), "w"(w2b));
    ZASSERT(w2c[0] == 10000U);
    ZASSERT(w2c[1] == 2000U);
    ZASSERT(w2c[2] == 2U && w2c[3] == 2U);

    /* smax/smin, .4s. */
    int32x4_t xa = {5, -5, INT32_MAX, INT32_MIN};
    int32x4_t xb = {3, 7, 0, 0};
    int32x4_t xc;
    asm volatile("smax %0.4s, %1.4s, %2.4s" : "=w"(xc) : "w"(xa), "w"(xb));
    ZASSERT(xc[0] == 5 && xc[1] == 7 && xc[2] == INT32_MAX && xc[3] == 0);
    asm volatile("smin %0.4s, %1.4s, %2.4s" : "=w"(xc) : "w"(xa), "w"(xb));
    ZASSERT(xc[0] == 3 && xc[1] == -5 && xc[2] == 0 && xc[3] == INT32_MIN);

    /* umax/umin, .8h. */
    uint16x8_t ya = {0xFFFF, 0, 100, 200, 300, 400, 1, 2};
    uint16x8_t yb = {1, 0xFFFF, 200, 100, 300, 500, 2, 1};
    uint16x8_t yc;
    asm volatile("umax %0.8h, %1.8h, %2.8h" : "=w"(yc) : "w"(ya), "w"(yb));
    ZASSERT(yc[0] == 0xFFFF && yc[1] == 0xFFFF && yc[2] == 200 && yc[3] == 200);
    ZASSERT(yc[4] == 300 && yc[5] == 500 && yc[6] == 2 && yc[7] == 2);
    asm volatile("umin %0.8h, %1.8h, %2.8h" : "=w"(yc) : "w"(ya), "w"(yb));
    ZASSERT(yc[0] == 1 && yc[1] == 0 && yc[2] == 100 && yc[3] == 100);
    ZASSERT(yc[6] == 1 && yc[7] == 1);

    /* umin, .16b. */
    uint8x16_t za = {255, 0, 10, 200, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14};
    uint8x16_t zb = {1, 1, 20, 100, 3, 5, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14};
    uint8x16_t zc;
    asm volatile("umin %0.16b, %1.16b, %2.16b" : "=w"(zc) : "w"(za), "w"(zb));
    ZASSERT(zc[0] == 1 && zc[1] == 0 && zc[2] == 10 && zc[3] == 100);
    ZASSERT(zc[4] == 3 && zc[5] == 4);

    /* shadd: signed halving add, .8b. */
    int8x8_t ha = {100, -100, 127, -128, 3, 4, 5, 6};
    int8x8_t hb = {100, -100, 127, -128, 1, 2, 3, 4};
    int8x8_t hc;
    asm volatile("shadd %0.8b, %1.8b, %2.8b" : "=w"(hc) : "w"(ha), "w"(hb));
    ZASSERT(hc[0] == 100);  /* (200) >> 1 */
    ZASSERT(hc[1] == -100);
    ZASSERT(hc[2] == 127);  /* (254) >> 1 */
    ZASSERT(hc[3] == -128); /* (-256) >> 1 */
    ZASSERT(hc[4] == 2 && hc[5] == 3 && hc[6] == 4 && hc[7] == 5);

    /* shsub: signed halving subtract, .4h. */
    int16x4_t sa = {100, -100, 10, 5};
    int16x4_t sb = {40, -40, 20, 5};
    int16x4_t sc;
    asm volatile("shsub %0.4h, %1.4h, %2.4h" : "=w"(sc) : "w"(sa), "w"(sb));
    ZASSERT(sc[0] == 30 && sc[1] == -30 && sc[2] == -5 && sc[3] == 0);

    /* uhadd: unsigned halving add, .4s. */
    uint32x4_t ua2 = {0xFFFFFFFFU, 10, 20, 30};
    uint32x4_t ub2 = {0xFFFFFFFFU, 20, 30, 40};
    uint32x4_t uc2;
    asm volatile("uhadd %0.4s, %1.4s, %2.4s" : "=w"(uc2) : "w"(ua2), "w"(ub2));
    ZASSERT(uc2[0] == 0xFFFFFFFFU); /* (2^33-2) >> 1 */
    ZASSERT(uc2[1] == 15 && uc2[2] == 25 && uc2[3] == 35);

    /* uhsub: unsigned halving subtract, .8h. */
    uint16x8_t va = {0xFFFF, 10, 20, 30, 1, 2, 3, 4};
    uint16x8_t vb = {1, 20, 10, 30, 2, 1, 1, 1};
    uint16x8_t vc;
    asm volatile("uhsub %0.8h, %1.8h, %2.8h" : "=w"(vc) : "w"(va), "w"(vb));
    ZASSERT(vc[0] == 0x7FFF); /* (65535 - 1) >> 1 */
    ZASSERT(vc[1] == 0xFFFB); /* ((10-20) >> 1) = -5 */
    ZASSERT(vc[2] == 5);
    ZASSERT(vc[3] == 0);
    ZASSERT(vc[4] == 0xFFFF && vc[5] == 0 && vc[6] == 1 && vc[7] == 1);

    /* srhadd: rounding halving add, .4s. */
    int32x4_t ra = {5, -5, 3, 7};
    int32x4_t rb = {4, -4, 4, 8};
    int32x4_t rc;
    asm volatile("srhadd %0.4s, %1.4s, %2.4s" : "=w"(rc) : "w"(ra), "w"(rb));
    ZASSERT(rc[0] == 5 && rc[1] == -4 && rc[2] == 4 && rc[3] == 8);

    /* urhadd: rounding halving add, .8h. */
    uint16x8_t ta = {0xFFFF, 1, 3, 5, 7, 9, 11, 13};
    uint16x8_t tb = {0xFFFF, 2, 4, 6, 8, 10, 12, 14};
    uint16x8_t tc;
    asm volatile("urhadd %0.8h, %1.8h, %2.8h" : "=w"(tc) : "w"(ta), "w"(tb));
    ZASSERT(tc[0] == 0xFFFF); /* (2^16-1 + 1) >> 1 = 0x10000>>1... = 0x8000? */
    /* (0xFFFF + 0xFFFF + 1) >> 1 = 0xFFFF. */
    ZASSERT(tc[1] == 2); /* (1+2+1)>>1 = 2 */
    ZASSERT(tc[2] == 4 && tc[3] == 6 && tc[4] == 8);
    ZASSERT(tc[7] == 14);

    /* cmtst: bitwise test bits in common, .16b. */
    int8x16_t ca = {1, 0, 0xF0, 0x0F, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
    int8x16_t cb = {2, 2, 0x0F, 0x0F, 0, 6, 0, 8, 1, 1, 1, 1, 1, 1, 1, 1};
    int8x16_t cc;
    asm volatile("cmtst %0.16b, %1.16b, %2.16b" : "=w"(cc) : "w"(ca), "w"(cb));
    ZASSERT(cc[0] == 0);  /* 1 & 2 == 0 */
    ZASSERT(cc[1] == 0);  /* 0 & 2 == 0 */
    ZASSERT(cc[2] == 0);  /* 0xF0 & 0x0F == 0 */
    ZASSERT(cc[3] == -1); /* 0x0F & 0x0F != 0 */
    ZASSERT(cc[4] == 0);
    ZASSERT(cc[5] == -1);
    ZASSERT(cc[6] == 0);
    ZASSERT(cc[7] == -1);
    ZASSERT(cc[8] == -1); /* 9 & 1 */
    ZASSERT(cc[15] == 0); /* 16 & 1 */

    /* cmtst, .4s. */
    int32x4_t da = {1, 2, 0x80000000, 0x40000000};
    int32x4_t db = {2, 2, 0x40000000, 0x40000000};
    int32x4_t dc;
    asm volatile("cmtst %0.4s, %1.4s, %2.4s" : "=w"(dc) : "w"(da), "w"(db));
    ZASSERT(dc[0] == 0);
    ZASSERT(dc[1] == -1);
    ZASSERT(dc[2] == 0);
    ZASSERT(dc[3] == -1);

    /* pmul: polynomial multiply per byte, .16b. */
    uint8x16_t pa = {0x00, 0xFF, 0x57, 0x83, 0x01, 0x80, 0xAA, 0x55,
                     0x12, 0x34, 0x56, 0x78, 0x9A, 0xBC, 0xDE, 0xF0};
    uint8x16_t pb = {0x00, 0xFF, 0x83, 0x57, 0x02, 0x80, 0x55, 0xAA,
                     0x21, 0x43, 0x65, 0x87, 0xA9, 0xCB, 0xED, 0x0F};
    uint8x16_t pc;
    asm volatile("pmul %0.16b, %1.16b, %2.16b" : "=w"(pc) : "w"(pa), "w"(pb));
    for (int i = 0; i < 16; ++i)
        ZASSERT(pc[i] == pmul8((uint8_t)pa[i], (uint8_t)pb[i]));
    ZASSERT(pc[0] == 0);
    ZASSERT(pc[1] == 0x55); /* 0xFF * 0xFF carry-less, truncated to 8 bits */
    ZASSERT(pc[4] == 0x02); /* x * (x<<1) = x<<1 */
    ZASSERT(pc[5] == 0x00); /* 0x80 * 0x80 = x^14, truncated away */
    ZASSERT(pc[6] == pmul8(0xAA, 0x55));

    /* urecpe: unsigned reciprocal estimate, checked against the exact
       architecture pseudocode reference. */
    uint32x4_t ea = {0x80000000u, 0x00000000u, 0xFFFFFFFFu, 0x7FFFFFFFu};
    uint32x4_t er;
    asm volatile("urecpe %0.4s, %1.4s" : "=w"(er) : "w"(ea));
    ZASSERT(er[0] == urecpe_ref(0x80000000u));
    ZASSERT(er[1] == urecpe_ref(0x00000000u));
    ZASSERT(er[2] == urecpe_ref(0xFFFFFFFFu));
    ZASSERT(er[3] == urecpe_ref(0x7FFFFFFFu));
    ZASSERT(er[1] == 0xFFFFFFFFu);
    ZASSERT(er[3] == 0xFFFFFFFFu);
    ZASSERT(er[0] == 0xFF800000u);
    ZASSERT(er[2] == 0x80000000u);

    uint32x2_t ea2 = {0xC0000000u, 0x91234567u};
    uint32x2_t er2;
    asm volatile("urecpe %0.2s, %1.2s" : "=w"(er2) : "w"(ea2));
    ZASSERT(er2[0] == urecpe_ref(0xC0000000u));
    ZASSERT(er2[1] == urecpe_ref(0x91234567u));

    uint32x4_t ea3 = {0xDEADBEEFu, 0x80000001u, 0xFFFF0000u, 0x80000001u};
    uint32x4_t er3;
    asm volatile("urecpe %0.4s, %1.4s" : "=w"(er3) : "w"(ea3));
    for (int i = 0; i < 4; ++i)
        ZASSERT(er3[i] == urecpe_ref((uint32_t)ea3[i]));

    /* ursqrte: unsigned reciprocal square root estimate, checked against
       the exact architecture pseudocode reference. */
    uint32x4_t sa2 = {0x40000000u, 0x00000000u, 0xFFFFFFFFu, 0x3FFFFFFFu};
    uint32x4_t sr;
    asm volatile("ursqrte %0.4s, %1.4s" : "=w"(sr) : "w"(sa2));
    ZASSERT(sr[0] == ursqrte_ref(0x40000000u));
    ZASSERT(sr[1] == ursqrte_ref(0x00000000u));
    ZASSERT(sr[2] == ursqrte_ref(0xFFFFFFFFu));
    ZASSERT(sr[3] == ursqrte_ref(0x3FFFFFFFu));
    ZASSERT(sr[1] == 0xFFFFFFFFu);
    ZASSERT(sr[3] == 0xFFFFFFFFu);
    ZASSERT(sr[0] == 0xFF800000u);
    ZASSERT(sr[2] == 0x80000000u);

    uint32x4_t sa3 = {0x55555555u, 0x80000000u, 0x7FFFFFFFu, 0x40000001u};
    uint32x4_t sr3;
    asm volatile("ursqrte %0.4s, %1.4s" : "=w"(sr3) : "w"(sa3));
    for (int i = 0; i < 4; ++i)
        ZASSERT(sr3[i] == ursqrte_ref((uint32_t)sa3[i]));
    return 0;
}
