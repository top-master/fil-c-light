#include <stdfil.h>
#include <stdint.h>

/* FP vector compares produce 0/all-ones in the destination lanes; they do
   not touch NZCV (that is what makes them safe here, unlike fcmp which sets
   the FPSR flags and is rejected outright). All forms below are the plain
   Armv8.0-A Advanced SIMD ones, so no -march gating is needed. */

typedef float v4 __attribute__((vector_size(16)));
typedef double v2 __attribute__((vector_size(16)));
typedef uint32_t u4 __attribute__((vector_size(16)));
typedef uint64_t u2 __attribute__((vector_size(16)));

#define EQ_BITS 0xffffffffu

static uint32_t cmp_bits(float a, float b, int which)
{
    /* which: 0=eq, 1=ge, 2=gt, 3=le (vs zero), 4=lt (vs zero). The C
       comparisons below compile to the same IEEE comparisons the hardware
       performs. */
    switch (which) {
    case 0: return a == b ? EQ_BITS : 0;
    case 1: return a >= b ? EQ_BITS : 0;
    case 2: return a > b ? EQ_BITS : 0;
    case 3: return a <= b ? EQ_BITS : 0;
    default: return a < b ? EQ_BITS : 0;
    }
}

int main(void)
{
    /* fcmeq (vector, register): lane-wise equality, .4s. */
    v4 a = {1.0f, 2.0f, -0.0f, 0.0f};
    v4 b = {1.0f, 3.0f, 0.0f, 1.0f};
    u4 c;
    asm volatile("fcmeq %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == EQ_BITS); /* equal */
    ZASSERT(c[1] == 0);
    ZASSERT(c[2] == EQ_BITS); /* -0.0 == +0.0 */
    ZASSERT(c[3] == 0);

    /* fcmeq (vector, zero): compare against #0.0. */
    v4 n = {0.0f, -1.5f, 2.5f, -0.0f};
    asm volatile("fcmeq %0.4s, %1.4s, #0.0" : "=w"(c) : "w"(n));
    ZASSERT(c[0] == EQ_BITS && c[1] == 0 && c[2] == 0 && c[3] == EQ_BITS);

    /* NaN never compares equal. */
    float nanf = __builtin_nanf("");
    v4 nn = {1.0f, nanf, 3.0f, 0.0f};
    asm volatile("fcmeq %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(nn), "w"(nn));
    ZASSERT(c[0] == EQ_BITS);
    ZASSERT(c[1] == 0); /* NaN != NaN */
    ZASSERT(c[2] == EQ_BITS && c[3] == EQ_BITS);

    /* fcmge (vector, register): a >= b. */
    v4 g1 = {1.0f, -1.0f, 0.0f, -0.0f};
    v4 g2 = {1.0f, 1.0f, -0.0f, 0.0f};
    asm volatile("fcmge %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(g1), "w"(g2));
    ZASSERT(c[0] == EQ_BITS);
    ZASSERT(c[1] == 0);
    ZASSERT(c[2] == EQ_BITS); /* +0 >= -0 */
    ZASSERT(c[3] == EQ_BITS);

    /* fcmge (vector, zero). */
    v4 z = {0.0f, -0.0f, 1.5f, -2.5f};
    asm volatile("fcmge %0.4s, %1.4s, #0.0" : "=w"(c) : "w"(z));
    ZASSERT(c[0] == EQ_BITS);
    ZASSERT(c[1] == EQ_BITS); /* -0.0 >= +0.0 */
    ZASSERT(c[2] == EQ_BITS);
    ZASSERT(c[3] == 0);

    /* fcmgt (vector, register): a > b, and fcmgt (vector, zero). */
    v4 h1 = {1.0f, 1.0f, -1.0f, 0.5f};
    v4 h2 = {1.0f, 0.5f, -1.0f, -0.5f};
    asm volatile("fcmgt %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(h1), "w"(h2));
    ZASSERT(c[0] == 0 && c[1] == EQ_BITS && c[2] == 0 && c[3] == EQ_BITS);
    asm volatile("fcmgt %0.4s, %1.4s, #0.0" : "=w"(c) : "w"(z));
    ZASSERT(c[0] == 0 && c[1] == 0 && c[2] == EQ_BITS && c[3] == 0);

    /* fcmle (vector, zero): a <= 0.0. There is no register form of fcmle. */
    asm volatile("fcmle %0.4s, %1.4s, #0.0" : "=w"(c) : "w"(z));
    ZASSERT(c[0] == EQ_BITS && c[1] == EQ_BITS && c[2] == 0 && c[3] == EQ_BITS);

    /* fcmlt (vector, zero): a < 0.0. There is no register form of fcmlt. */
    asm volatile("fcmlt %0.4s, %1.4s, #0.0" : "=w"(c) : "w"(z));
    ZASSERT(c[0] == 0 && c[1] == 0 && c[2] == 0 && c[3] == EQ_BITS);

    /* The zero forms also take .2d (double) sources. */
    v2 da = {1.0, -1.0};
    u2 dc;
    uint64_t eq64 = ~(uint64_t)0;
    asm volatile("fcmgt %0.2d, %1.2d, #0.0" : "=w"(dc) : "w"(da));
    ZASSERT(dc[0] == eq64 && dc[1] == 0);
    asm volatile("fcmlt %0.2d, %1.2d, #0.0" : "=w"(dc) : "w"(da));
    ZASSERT(dc[0] == 0 && dc[1] == eq64);
    asm volatile("fcmge %0.2d, %1.2d, #0.0" : "=w"(dc) : "w"(da));
    ZASSERT(dc[0] == eq64 && dc[1] == 0);

    /* facge/facgt (vector): |a| >= |b| and |a| > |b|. */
    v4 f1 = {1.0f, -2.0f, 3.0f, -3.0f};
    v4 f2 = {-2.0f, 2.0f, -4.0f, 4.0f};
    asm volatile("facge %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(f1), "w"(f2));
    ZASSERT(c[0] == 0);        /* |1| >= |-2| false */
    ZASSERT(c[1] == EQ_BITS);  /* |-2| >= |2| true */
    ZASSERT(c[2] == 0);
    ZASSERT(c[3] == 0);      /* |-3| >= |4| false */
    asm volatile("facgt %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(f1), "w"(f2));
    ZASSERT(c[0] == 0 && c[1] == 0 && c[2] == 0 && c[3] == 0);
    v4 f3 = {5.0f, -5.0f, 0.25f, -0.25f};
    asm volatile("facgt %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(f3), "w"(f2));
    ZASSERT(c[0] == EQ_BITS && c[1] == EQ_BITS && c[2] == 0 && c[3] == 0);

    /* facge/facgt (scalar): |s1| vs |s2|. */
    float fs1 = 2.0f, fs2 = -3.0f;
    uint32_t sr;
    asm volatile("facge %s0, %s1, %s2" : "=w"(sr) : "w"(fs1), "w"(fs2));
    ZASSERT(sr == 0);
    asm volatile("facgt %s0, %s1, %s2" : "=w"(sr) : "w"(fs2), "w"(fs1));
    ZASSERT(sr == EQ_BITS); /* |-3| > |2| */

    /* Scalar zero-compare forms of the fcmeq family. */
    float sz = -0.0f;
    asm volatile("fcmeq %s0, %s1, #0.0" : "=w"(sr) : "w"(sz));
    ZASSERT(sr == EQ_BITS); /* -0.0 == +0.0 */
    asm volatile("fcmge %s0, %s1, #0.0" : "=w"(sr) : "w"(sz));
    ZASSERT(sr == EQ_BITS);
    asm volatile("fcmle %s0, %s1, #0.0" : "=w"(sr) : "w"(sz));
    ZASSERT(sr == EQ_BITS);
    asm volatile("fcmlt %s0, %s1, #0.0" : "=w"(sr) : "w"(sz));
    ZASSERT(sr == 0);
    float sn = 7.0f;
    asm volatile("fcmgt %s0, %s1, #0.0" : "=w"(sr) : "w"(sn));
    ZASSERT(sr == EQ_BITS);

    /* NaN in a scalar zero compare yields false, and NaN in facge/facgt
       yields false (unordered). */
    asm volatile("fcmeq %s0, %s1, #0.0" : "=w"(sr) : "w"(nanf));
    ZASSERT(sr == 0);
    asm volatile("facge %s0, %s1, %s2" : "=w"(sr) : "w"(nanf), "w"(sn));
    ZASSERT(sr == 0);

    /* Sanity: the C reference agrees with a spread of values. */
    float vals[6] = {0.0f, -0.0f, 1.5f, -1.5f, 1234.5f, -98765.25f};
    for (int i = 0; i < 6; ++i) {
        v4 va; va[0] = vals[i]; va[1] = 0.0f; va[2] = 0.0f; va[3] = 0.0f;
        u4 got;
        asm volatile("fcmeq %0.4s, %1.4s, #0.0" : "=w"(got) : "w"(va));
        ZASSERT(got[0] == cmp_bits(vals[i], 0.0f, 0));
        asm volatile("fcmge %0.4s, %1.4s, #0.0" : "=w"(got) : "w"(va));
        ZASSERT(got[0] == cmp_bits(vals[i], 0.0f, 1));
        asm volatile("fcmgt %0.4s, %1.4s, #0.0" : "=w"(got) : "w"(va));
        ZASSERT(got[0] == cmp_bits(vals[i], 0.0f, 2));
        asm volatile("fcmle %0.4s, %1.4s, #0.0" : "=w"(got) : "w"(va));
        ZASSERT(got[0] == cmp_bits(vals[i], 0.0f, 3));
        asm volatile("fcmlt %0.4s, %1.4s, #0.0" : "=w"(got) : "w"(va));
        ZASSERT(got[0] == cmp_bits(vals[i], 0.0f, 4));
    }
    return 0;
}
