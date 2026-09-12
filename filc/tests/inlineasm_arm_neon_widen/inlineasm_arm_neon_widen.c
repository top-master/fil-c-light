#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>

/* Saturation helpers matching SignedSatQ. */
static int32_t sat32(__int128 x)
{
    if (x > (__int128)INT32_MAX) return INT32_MAX;
    if (x < (__int128)INT32_MIN) return INT32_MIN;
    return (int32_t)x;
}

static int64_t sat64(__int128 x)
{
    if (x > (__int128)INT64_MAX) return INT64_MAX;
    if (x < (__int128)INT64_MIN) return INT64_MIN;
    return (int64_t)x;
}

static int16_t sat16(int64_t x)
{
    if (x > INT16_MAX) return INT16_MAX;
    if (x < INT16_MIN) return INT16_MIN;
    return (int16_t)x;
}

int main(void)
{
    /* saddl: widening add of the low halves, .8h <- .8b. */
    int8x8_t sa = {-128, 127, 1, -1, 10, -10, 100, 5};
    int8x8_t sb = {127, 127, 2, -2, 20, -20, -100, -5};
    int16x8_t sc;
    asm volatile("saddl %0.8h, %1.8b, %2.8b" : "=w"(sc) : "w"(sa), "w"(sb));
    for (int i = 0; i < 8; ++i)
        ZASSERT(sc[i] == (int16_t)((int)sa[i] + (int)sb[i]));
    ZASSERT(sc[0] == -1 && sc[1] == 254 && sc[6] == 0);

    /* saddl2: widening add of the high halves, .4s <- .8h. */
    int16x8_t ha = {0, 0, 0, 0, 30000, -30000, 1234, -4321};
    int16x8_t hb = {0, 0, 0, 0, 10000, -10000, 4321, -1234};
    int32x4_t hc;
    asm volatile("saddl2 %0.4s, %1.8h, %2.8h" : "=w"(hc) : "w"(ha), "w"(hb));
    ZASSERT(hc[0] == 40000);
    ZASSERT(hc[1] == -40000);
    ZASSERT(hc[2] == 5555);
    ZASSERT(hc[3] == -5555);

    /* uaddl: widening unsigned add, .8h <- .8b. */
    uint8x8_t ua = {255, 200, 1, 0, 128, 127, 3, 4};
    uint8x8_t ub = {255, 100, 2, 0, 128, 1, 5, 6};
    uint16x8_t uc;
    asm volatile("uaddl %0.8h, %1.8b, %2.8b" : "=w"(uc) : "w"(ua), "w"(ub));
    ZASSERT(uc[0] == 510 && uc[1] == 300 && uc[2] == 3 && uc[3] == 0);
    ZASSERT(uc[4] == 256 && uc[7] == 10);

    /* ssubl: widening subtract, .8h <- .8b. */
    int16x8_t ssc;
    asm volatile("ssubl %0.8h, %1.8b, %2.8b" : "=w"(ssc) : "w"(sb), "w"(sa));
    for (int i = 0; i < 8; ++i)
        ZASSERT(ssc[i] == (int16_t)((int)sb[i] - (int)sa[i]));
    ZASSERT(ssc[0] == 255 && ssc[3] == -1);

    /* usubl2: widening unsigned subtract of the high halves, .4s <- .8h. */
    uint16x8_t uha = {0, 0, 0, 0, 60000, 1000, 5000, 2};
    uint16x8_t uhb = {0, 0, 0, 0, 50000, 3000, 4000, 7};
    uint32x4_t usc;
    asm volatile("usubl2 %0.4s, %1.8h, %2.8h" : "=w"(usc) : "w"(uha), "w"(uhb));
    ZASSERT(usc[0] == 10000U);
    ZASSERT(usc[1] == (uint32_t)-2000);
    ZASSERT(usc[2] == 1000U);
    ZASSERT(usc[3] == (uint32_t)-5);

    /* saddw: add widened single-width to double-width, .4s <- .4h. */
    int32x4_t wa = {1000000, -7, 3, 4};
    int16x4_t wb = {30000, -30000, 1, 2};
    int32x4_t wc;
    asm volatile("saddw %0.4s, %1.4s, %2.4h" : "=w"(wc) : "w"(wa), "w"(wb));
    ZASSERT(wc[0] == 1030000);
    ZASSERT(wc[1] == -30007);
    ZASSERT(wc[2] == 4 && wc[3] == 6);

    /* uaddw2: unsigned, subtractend from the high half, .4s <- .8h. */
    uint32x4_t uwa = {0xFFFFFFFFU, 10, 20, 30};
    uint16x8_t uwb = {0, 0, 0, 0, 2, 3, 4, 5};
    uint32x4_t uwc;
    asm volatile("uaddw2 %0.4s, %1.4s, %2.8h" : "=w"(uwc) : "w"(uwa), "w"(uwb));
    ZASSERT(uwc[0] == 1U); /* wraps */
    ZASSERT(uwc[1] == 13U && uwc[2] == 24U && uwc[3] == 35U);

    /* usubw: subtract widened from double-width, .4s <- .4h. */
    uint32x4_t swa = {100, 0, 5, 9};
    int16x4_t swb = {1, 1, 3, 0};
    uint32x4_t swc;
    asm volatile("usubw %0.4s, %1.4s, %2.4h" : "=w"(swc) : "w"(swa), "w"(swb));
    ZASSERT(swc[0] == 99U);
    ZASSERT(swc[1] == 0xFFFFFFFFU); /* 0 - 1 wraps */
    ZASSERT(swc[2] == 2U && swc[3] == 9U);

    /* addhn: add and return high halves, .4h <- .4s. */
    uint32x4_t aa = {0x00010000U, 0x00008000U, 5U, 0xFFFFFFFFU};
    uint32x4_t ab = {0x00010000U, 0x00008000U, 6U, 1U};
    int16x4_t ac;
    asm volatile("addhn %0.4h, %1.4s, %2.4s" : "=w"(ac) : "w"(aa), "w"(ab));
    ZASSERT(ac[0] == 2);       /* (0x20000 >> 16) */
    ZASSERT(ac[1] == 1);       /* (0x10000 >> 16) */
    ZASSERT(ac[2] == 0);       /* (0xB >> 16) */
    ZASSERT(ac[3] == 0);       /* (0x100000000 >> 16) truncates to 0 */

    /* addhn2: results in the upper half; lower half preserved (tied). */
    uint32x4_t a2a = {0x00010000U, 0x00020000U, 0x00030000U, 0x00040000U};
    uint32x4_t a2b = {0x00010000U, 0x00010000U, 0x00010000U, 0x00010000U};
    int16x8_t a2c;
    int16x8_t a2keep = {0x1111, 0x2222, 0x3333, 0x4444, 0, 0, 0, 0};
    a2c = a2keep;
    asm volatile("addhn2 %0.8h, %1.4s, %2.4s" : "+w"(a2c) : "w"(a2a), "w"(a2b));
    ZASSERT(a2c[0] == 0x1111 && a2c[1] == 0x2222);
    ZASSERT(a2c[2] == 0x3333 && a2c[3] == 0x4444); /* preserved */
    ZASSERT(a2c[4] == 2 && a2c[5] == 3 && a2c[6] == 4 && a2c[7] == 5);

    /* raddhn: rounding add and return high halves, .4h <- .4s. */
    int16x4_t rc;
    asm volatile("raddhn %0.4h, %1.4s, %2.4s" : "=w"(rc) : "w"(aa), "w"(ab));
    ZASSERT(rc[0] == 2); /* (0x20000 + 0x8000) >> 16 */
    ZASSERT(rc[1] == 1); /* (0x10000 + 0x8000) >> 16 */
    ZASSERT(rc[2] == 0); /* (0xB + 0x8000) >> 16 */

    /* rsubhn2: rounding subtract, high halves of dest preserved (tied). */
    uint32x4_t rs2a = {0x00050000U, 0x00001000U, 0x00010000U, 7U};
    uint32x4_t rs2b = {0x00010000U, 0x00000000U, 0x00010000U, 0x00010000U};
    int16x8_t rs2c = {0x0F0F, 0x00FF, 0x55AA, 0xA55A, 0, 0, 0, 0};
    asm volatile("rsubhn2 %0.8h, %1.4s, %2.4s" : "+w"(rs2c) : "w"(rs2a), "w"(rs2b));
    ZASSERT(rs2c[0] == 0x0F0F && rs2c[1] == 0x00FF); /* preserved */
    ZASSERT(rs2c[2] == 0x55AA && rs2c[3] == (int16_t)0xA55A);
    ZASSERT(rs2c[4] == 4); /* (0x40000 + 0x8000) >> 16 */
    ZASSERT(rs2c[5] == 0); /* (0x1000 + 0x8000) >> 16 */
    ZASSERT(rs2c[6] == 0); /* (0 + 0x8000) >> 16 */
    ZASSERT(rs2c[7] == (int16_t)0xFFFF); /* (7 - 0x10000 + 0x8000) >> 16 = -1 */

    /* umlal: widening multiply accumulate (tied), .8h <- .8b. */
    uint8x8_t ma = {200, 2, 10, 255, 3, 4, 5, 6};
    uint8x8_t mb = {2, 3, 10, 1, 7, 8, 9, 10};
    int16x8_t macc = {10, 10, 0, 0, 100, 100, 100, 100};
    asm volatile("umlal %0.8h, %1.8b, %2.8b" : "+w"(macc) : "w"(ma), "w"(mb));
    ZASSERT(macc[0] == 410);
    ZASSERT(macc[1] == 16);
    ZASSERT(macc[2] == 100);
    ZASSERT(macc[3] == 255);
    ZASSERT(macc[4] == 121);
    ZASSERT(macc[5] == 132);
    ZASSERT(macc[6] == 145);
    ZASSERT(macc[7] == 160);

    /* umlal2: high halves of the sources (tied), .4s <- .8h. */
    uint16x8_t m2a = {0, 0, 0, 0, 60000, 1000, 2, 3};
    uint16x8_t m2b = {0, 0, 0, 0, 2, 3, 4, 5};
    uint32x4_t m2acc = {1000, 1000, 1000, 1000};
    asm volatile("umlal2 %0.4s, %1.8h, %2.8h" : "+w"(m2acc) : "w"(m2a), "w"(m2b));
    ZASSERT(m2acc[0] == 1000U + 120000U);
    ZASSERT(m2acc[1] == 1000U + 3000U);
    ZASSERT(m2acc[2] == 1008U && m2acc[3] == 1015U);

    /* smlsl: widening multiply subtract (tied), .8h <- .8b. */
    int8x8_t la = {-128, 100, 3, 4, 5, 6, 7, 8};
    int8x8_t lb = {2, -3, 4, 5, 6, 7, 8, 9};
    int16x8_t lacc = {0, 10, 10, 10, 10, 10, 10, 10};
    asm volatile("smlsl %0.8h, %1.8b, %2.8b" : "+w"(lacc) : "w"(la), "w"(lb));
    ZASSERT(lacc[0] == 256);  /* 0 - (-128 * 2) */
    ZASSERT(lacc[1] == 310);  /* 10 - (100 * -3) */
    ZASSERT(lacc[2] == -2);   /* 10 - 12 */
    ZASSERT(lacc[7] == -62);  /* 10 - 72 */

    /* smlal by element (tied), .4s <- .4h with v2.h[3]. */
    int16x4_t ela = {100, -100, 300, -300};
    int16x8_t elb = {0, 0, 0, 7, 0, 0, 0, 0};
    int32x4_t elacc = {5, 5, 5, 5};
    asm volatile("smlal %0.4s, %1.4h, %2.h[3]" : "+w"(elacc) : "w"(ela), "w"(elb));
    ZASSERT(elacc[0] == 705);
    ZASSERT(elacc[1] == -695);
    ZASSERT(elacc[2] == 2105);
    ZASSERT(elacc[3] == -2095);

    /* sqdmlal: saturating doubling multiply accumulate (tied), .4s <- .4h. */
    int16x4_t qa = {30000, -30000, 100, 2};
    int16x4_t qb = {2, 2, 300, 3};
    int32x4_t qacc = {100, 100, 100, 100};
    asm volatile("sqdmlal %0.4s, %1.4h, %2.4h" : "+w"(qacc) : "w"(qa), "w"(qb));
    ZASSERT(qacc[0] == 120100); /* 100 + 2*30000*2 */
    ZASSERT(qacc[1] == -119900);
    ZASSERT(qacc[2] == 60100);
    ZASSERT(qacc[3] == 112);
    /* Saturation of the product and of the accumulate. */
    int16x4_t qa2 = {-32768, 32767, 0, 0};
    int16x4_t qb2 = {-32768, 32767, 0, 0};
    int32x4_t qacc2 = {0, INT32_MAX, 0, 0};
    asm volatile("sqdmlal %0.4s, %1.4h, %2.4h" : "+w"(qacc2) : "w"(qa2), "w"(qb2));
    ZASSERT(qacc2[0] == INT32_MAX); /* 2*(-32768)^2 saturates */
    ZASSERT(qacc2[1] == INT32_MAX); /* accumulate saturates */
    ZASSERT(qacc2[2] == 0 && qacc2[3] == 0);

    /* sqdmlsl2: saturating doubling multiply subtract (tied), .4s <- .8h. */
    int16x8_t qs2a = {0, 0, 0, 0, 30000, 100, 1, 1};
    int16x8_t qs2b = {0, 0, 0, 0, 2, 300, 2, 3};
    int32x4_t qs2acc = {0, 100, 5, 10};
    asm volatile("sqdmlsl2 %0.4s, %1.8h, %2.8h" : "+w"(qs2acc) : "w"(qs2a), "w"(qs2b));
    ZASSERT(qs2acc[0] == -120000);
    ZASSERT(qs2acc[1] == 100 - 60000);
    ZASSERT(qs2acc[2] == 1); /* 5 - 2*1*2 */
    ZASSERT(qs2acc[3] == 4);

    /* sqdmlal by element (tied), .4s <- .4h with v2.h[7]. */
    int16x4_t qea = {20000, -20000, 1, 2};
    int16x8_t qeb = {0, 0, 0, 0, 0, 0, 0, -3};
    int32x4_t qeacc = {0, 0, 0, 0};
    asm volatile("sqdmlal %0.4s, %1.4h, %2.h[7]" : "+w"(qeacc) : "w"(qea), "w"(qeb));
    ZASSERT(qeacc[0] == -120000);
    ZASSERT(qeacc[1] == 120000);
    ZASSERT(qeacc[2] == -6 && qeacc[3] == -12);

    /* sqdmull: saturating doubling multiply long, .4s <- .4h. */
    int16x4_t da = {30000, -30000, 3, -4};
    int16x4_t db = {2, 2, 5, 6};
    int32x4_t dc;
    asm volatile("sqdmull %0.4s, %1.4h, %2.4h" : "=w"(dc) : "w"(da), "w"(db));
    ZASSERT(dc[0] == 120000);
    ZASSERT(dc[1] == -120000);
    ZASSERT(dc[2] == 30 && dc[3] == -48);
    /* Saturation: 2 * -32768 * -32768 overflows 32 bits. */
    int16x4_t da2 = {-32768, 32767, 0, 0};
    int16x4_t db2 = {-32768, 32767, 0, 0};
    int32x4_t dc2;
    asm volatile("sqdmull %0.4s, %1.4h, %2.4h" : "=w"(dc2) : "w"(da2), "w"(db2));
    ZASSERT(dc2[0] == INT32_MAX); /* 2*(-32768)*(-32768) saturates */
    ZASSERT(dc2[1] == 2147352578); /* 2*32767*32767, no saturation */
    ZASSERT(dc2[2] == 0 && dc2[3] == 0);

    /* sqdmull2: high halves, .2d <- .4s. */
    int32x4_t d2a = {0, 0, 2000000000, -5};
    int32x4_t d2b = {0, 0, 3, -7};
    int64x2_t d2c;
    asm volatile("sqdmull2 %0.2d, %1.4s, %2.4s" : "=w"(d2c) : "w"(d2a), "w"(d2b));
    ZASSERT(d2c[0] == 12000000000LL);
    ZASSERT(d2c[1] == 70LL);

    /* sqdmull by element, .4s <- .4h with v2.h[7]. */
    int16x4_t dea = {1000, -1000, 3, 4};
    int16x8_t deb = {0, 0, 0, 0, 0, 0, 0, -9};
    int32x4_t dec;
    asm volatile("sqdmull %0.4s, %1.4h, %2.h[7]" : "=w"(dec) : "w"(dea), "w"(deb));
    ZASSERT(dec[0] == -18000 && dec[1] == 18000 && dec[2] == -54 && dec[3] == -72);

    /* sqdmulh: saturating doubling multiply high half, .4s.
       Result lane = sat32((2*a*b) >> 32). */
    int32x4_t ma2 = {1, -1, 0x40000000, INT32_MIN};
    int32x4_t mb2 = {1, 1, 0x40000000, INT32_MIN};
    int32x4_t mc2;
    asm volatile("sqdmulh %0.4s, %1.4s, %2.4s" : "=w"(mc2) : "w"(ma2), "w"(mb2));
    ZASSERT(mc2[0] == 0);  /* 2 >> 32 = 0 */
    ZASSERT(mc2[1] == -1); /* -2 >> 32 = -1 */
    ZASSERT(mc2[2] == 0x20000000); /* 2*2^60 >> 32 = 2^29 */
    ZASSERT(mc2[3] == INT32_MAX);  /* 2*INT32_MIN^2 = 2^63 >> 32 = 2^31 saturates */

    /* sqrdmulh: rounding version, .8h. */
    int16x8_t ra = {32767, -32768, 1000, -1000, 3, 4, 5, 6};
    int16x8_t rb = {32767, -32768, 1000, -1000, 7, 8, 9, 10};
    int16x8_t rc2;
    asm volatile("sqrdmulh %0.8h, %1.8h, %2.8h" : "=w"(rc2) : "w"(ra), "w"(rb));
    for (int i = 0; i < 8; ++i)
        ZASSERT(rc2[i] == sat16(((int64_t)ra[i] * rb[i] * 2 + 0x8000) >> 16));
    ZASSERT(rc2[1] == INT16_MAX); /* (-32768)^2 doubling saturates */
    ZASSERT(rc2[2] == 31);

    /* smull: plain widening multiply, .8h <- .8b. */
    int8x8_t pa = {-128, 127, 3, 4, 5, 6, 7, 8};
    int8x8_t pb = {2, 2, 3, 4, 5, 6, 7, 8};
    int16x8_t pc;
    asm volatile("smull %0.8h, %1.8b, %2.8b" : "=w"(pc) : "w"(pa), "w"(pb));
    ZASSERT(pc[0] == -256 && pc[1] == 254 && pc[7] == 64);

    /* smull2: high halves, .4s <- .8h. */
    int16x8_t p2a = {0, 0, 0, 0, 30000, -30000, 5, 6};
    int16x8_t p2b = {0, 0, 0, 0, 2, 2, 7, 8};
    int32x4_t p2c;
    asm volatile("smull2 %0.4s, %1.8h, %2.8h" : "=w"(p2c) : "w"(p2a), "w"(p2b));
    ZASSERT(p2c[0] == 60000 && p2c[1] == -60000);
    ZASSERT(p2c[2] == 35 && p2c[3] == 48);

    /* umull2: unsigned high halves, .2d <- .4s. */
    uint32x4_t u2a = {0, 0, 4000000000U, 100000U};
    uint32x4_t u2b = {0, 0, 3U, 200000U};
    uint64x2_t u2c;
    asm volatile("umull2 %0.2d, %1.4s, %2.4s" : "=w"(u2c) : "w"(u2a), "w"(u2b));
    ZASSERT(u2c[0] == 12000000000ULL);
    ZASSERT(u2c[1] == 20000000000ULL);
    return 0;
}
