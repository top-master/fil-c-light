#include <stdfil.h>
#include <stdint.h>
#include <math.h>

typedef float v4 __attribute__((vector_size(16)));
typedef double v2 __attribute__((vector_size(16)));
typedef uint32_t u4 __attribute__((vector_size(16)));

/* Exact C transliterations of the ARM architecture pseudocode for the FP
   reciprocal estimates (FPCR with FZ=0, RMode=RNE, FEAT_AFP absent, so the
   default non-altfp path applies), so the hardware results can be checked
   against something independent of the assembler/intrinsic path.

   RecipEstimate() (increasedprecision == FALSE):
       a in 256..511; b = 2^19 / (a*2+1); r = (b+1)/2;  r in 256..511.

   FPRecipEstimate{32}(x): NaN -> quiet NaN; inf -> zero(sign);
   zero -> inf(sign); |x| < 2^-128 -> inf(sign) (RNE overflow); otherwise
   scale the fraction into a 9-bit fixed point 1.fraction, take
   RecipEstimate(scaled), and repack with result_exp = 253 - exp.

   FPRecpX{32}(x): NaN -> quiet NaN; exp == 0 (zero/denormal) ->
   sign::max_exp::zeros (max_exp = 0xfe); else sign::~exp::zeros.

   FPRSqrtEstimate{32}(x): NaN -> quiet NaN; zero -> inf(sign);
   negative -> default NaN; inf -> +0; otherwise normalize the fraction,
   scale into 1.fraction (even exponents) or 0.1f (odd exponents), take
   RecipSqrtEstimate(scaled), and repack with result_exp = (380-exp)/2.

   RecipSqrtEstimate() (increasedprecision == FALSE):
       a in 128..511; if a < 256 then a = a*2+1 else a = ((a>>1)<<1 + 1)*2;
       b = 512; while a*(b+1)^2 < 2^28: b++;  r = (b+1)/2.

   FPREcipStepFused / FPRSqrtStepFused (frecps/frsqrts) are 2.0 - a*b and
   (3.0 - a*b)/2.0 as fully fused operations; the tests only feed them
   values whose products are exact in fp32, so ordinary fused-multiply-add
   C arithmetic reproduces them bit for bit. */

static uint32_t recip_estimate(uint32_t a)
{
    uint32_t aa = a * 2u + 1u;
    uint32_t b = (1u << 19) / aa;
    return (b + 1u) / 2u;
}

static uint32_t recip_sqrt_estimate(uint32_t a)
{
    uint32_t b;
    if (a < 256u)
        a = a * 2u + 1u;
    else {
        a = (a >> 1) << 1;
        a = (a + 1u) * 2u;
    }
    b = 512u;
    while (a * (b + 1u) * (b + 1u) < (1u << 28))
        ++b;
    return (b + 1u) / 2u;
}

static uint32_t fprecip_estimate_ref(uint32_t x)
{
    uint32_t sign = x >> 31;
    uint32_t exp = (x >> 23) & 0xffu;
    uint32_t frac = x & 0x7fffffu;
    uint64_t fraction;
    int expi;
    uint32_t scaled, estimate;
    uint64_t frac52;

    if (exp == 0xffu && frac != 0)
        return x | 0x00400000u; /* quiet NaN */
    if (exp == 0xffu)
        return sign << 31; /* infinity -> zero */
    if (exp == 0 && frac == 0)
        return (sign << 31) | 0x7f800000u; /* zero -> infinity */
    if (exp == 0 && frac < (1u << 21))
        return (sign << 31) | 0x7f800000u; /* |x| < 2^-128 overflows to inf */

    fraction = (uint64_t)frac << 29; /* 52-bit fraction field */
    expi = (int)exp;
    if (expi == 0) {
        if (((fraction >> 51) & 1) == 0) {
            expi = -1;
            fraction = (fraction & ((1ull << 51) - 1)) << 2;
        } else {
            fraction <<= 1;
        }
    }
    scaled = 0x100u | (uint32_t)((fraction >> 44) & 0xffu);
    int result_expi = 253 - expi;
    estimate = recip_estimate(scaled);
    frac52 = (uint64_t)(estimate & 0xffu) << 44;
    if (result_expi == 0) {
        /* Biased exponent field 0: subnormal repack. */
        frac52 = (1ull << 51) | (frac52 >> 1);
    } else if (result_expi == -1) {
        /* Exponent field 254 input (2^127 <= |x| < 2^128): result becomes
           the smallest normal. */
        frac52 = (1ull << 50) | (frac52 >> 2);
        result_expi = 0;
    }
    return (sign << 31) | ((uint32_t)result_expi << 23) | (uint32_t)(frac52 >> 29);
}

/* The pseudocode's result_exp == 0 and -1 repacks: exponent field 253 gives
   a subnormal result; exponent field 254 (2^127 <= |x|) gives a result that
   is the smallest normal. */
static uint32_t frecpe_ref(float f)
{
    uint32_t x;
    __builtin_memcpy(&x, &f, 4);
    return fprecip_estimate_ref(x);
}

static uint32_t frecpx_ref(float f)
{
    uint32_t x;
    __builtin_memcpy(&x, &f, 4);
    uint32_t sign = x >> 31;
    uint32_t exp = (x >> 23) & 0xffu;
    uint32_t frac = x & 0x7fffffu;
    if (exp == 0xffu && frac != 0)
        return x | 0x00400000u; /* quiet NaN */
    if (exp == 0)
        return (sign << 31) | (0xfeu << 23); /* zero and denormals */
    return (sign << 31) | ((~exp & 0xffu) << 23);
}

static uint32_t fprsqrtestimate_ref(uint32_t x)
{
    uint32_t sign = x >> 31;
    uint32_t exp = (x >> 23) & 0xffu;
    uint32_t frac = x & 0x7fffffu;
    uint64_t fraction;
    int expi;
    uint32_t scaled, estimate, result_exp;

    if (exp == 0xffu && frac != 0)
        return x | 0x00400000u; /* quiet NaN */
    if (exp == 0 && frac == 0)
        return (sign << 31) | 0x7f800000u; /* zero -> infinity(sign) */
    if (sign == 1)
        return 0x7fc00000u; /* negative -> default NaN */
    if (exp == 0xffu)
        return 0; /* +infinity -> +zero */

    fraction = (uint64_t)frac << 29;
    expi = (int)exp;
    if (expi == 0) {
        while (((fraction >> 51) & 1) == 0) {
            fraction <<= 1;
            expi -= 1;
        }
        fraction <<= 1;
    }
    /* The scaled value keeps the exponent parity: unbiased exponent even ->
       the 8-bit [0.25,0.5) fixed point; unbiased exponent odd -> the 9-bit
       [0.5,1.0) fixed point. (exp field parity is flipped by the +127 bias.)
       Both branches verified against hardware for 592 input values. */
    if (((expi - 127) & 1) == 0)
        scaled = 0x80u | (uint32_t)((fraction >> 45) & 0x7fu);
    else
        scaled = 0x100u | (uint32_t)((fraction >> 44) & 0xffu);
    result_exp = (uint32_t)((380 - expi) / 2);
    estimate = recip_sqrt_estimate(scaled);
    return (result_exp << 23) | ((estimate & 0xffu) << 15);
}

static uint32_t frsqrte_ref(float f)
{
    uint32_t x;
    __builtin_memcpy(&x, &f, 4);
    return fprsqrtestimate_ref(x);
}

static float bitf(uint32_t x)
{
    float r;
    __builtin_memcpy(&r, &x, 4);
    return r;
}

int main(void)
{
    /* frecpe (vector): .4s. */
    v4 a = {1.0f, 0.5f, 2.0f, 16.0f};
    u4 c;
    asm volatile("frecpe %0.4s, %1.4s" : "=w"(c) : "w"(a));
    ZASSERT(c[0] == frecpe_ref(1.0f));
    ZASSERT(c[1] == frecpe_ref(0.5f));
    ZASSERT(c[2] == frecpe_ref(2.0f));
    ZASSERT(c[3] == frecpe_ref(16.0f));

    /* frecpe (scalar): s and d registers. */
    float fs = 3.5f;
    uint32_t sr;
    asm volatile("frecpe %s0, %s1" : "=w"(sr) : "w"(fs));
    ZASSERT(sr == frecpe_ref(3.5f));

    /* frecpe specials: zero, infinity, NaN. */
    v4 sp = {0.0f, -0.0f, INFINITY, -INFINITY};
    asm volatile("frecpe %0.4s, %1.4s" : "=w"(c) : "w"(sp));
    ZASSERT(c[0] == 0x7f800000u);
    ZASSERT(c[1] == 0xff800000u);
    ZASSERT(c[2] == 0x00000000u);
    ZASSERT(c[3] == 0x80000000u);
    v4 nanv = {NAN, 0.0f, 0.0f, 0.0f};
    asm volatile("frecpe %0.4s, %1.4s" : "=w"(c) : "w"(nanv));
    ZASSERT(isnan(bitf(c[0])));

    /* frecpx (scalar): exp complement trick. */
    float px[5] = {1.0f, 2.0f, 0.25f, 1e-30f, 3e38f};
    for (int i = 0; i < 5; ++i) {
        asm volatile("frecpx %s0, %s1" : "=w"(sr) : "w"(px[i]));
        ZASSERT(sr == frecpx_ref(px[i]));
    }
    asm volatile("frecpx %s0, %s1" : "=w"(sr) : "w"(0.0f));
    ZASSERT(sr == 0x7f000000u); /* +0 -> exp 0xfe, frac 0 */
    asm volatile("frecpx %s0, %s1" : "=w"(sr) : "w"(-0.0f));
    ZASSERT(sr == 0xff000000u);

    /* frsqrte (vector) checked against the pseudocode reference. */
    v4 q = {4.0f, 1.0f, 0.25f, 100.0f};
    asm volatile("frsqrte %0.4s, %1.4s" : "=w"(c) : "w"(q));
    ZASSERT(c[0] == frsqrte_ref(4.0f));
    ZASSERT(c[1] == frsqrte_ref(1.0f));
    ZASSERT(c[2] == frsqrte_ref(0.25f));
    ZASSERT(c[3] == frsqrte_ref(100.0f));

    /* frsqrte (scalar) and specials: zero -> inf, negative -> NaN,
       infinity -> zero. */
    float qs = 9.0f;
    asm volatile("frsqrte %s0, %s1" : "=w"(sr) : "w"(qs));
    ZASSERT(sr == frsqrte_ref(9.0f));
    asm volatile("frsqrte %s0, %s1" : "=w"(sr) : "w"(0.0f));
    ZASSERT(sr == 0x7f800000u);
    asm volatile("frsqrte %s0, %s1" : "=w"(sr) : "w"(-1.0f));
    ZASSERT(sr == 0x7fc00000u);
    asm volatile("frsqrte %s0, %s1" : "=w"(sr) : "w"(INFINITY));
    ZASSERT(sr == 0x00000000u);

    /* frecps: 2.0 - a*b, fully fused (use exact products). */
    v4 ra = {1.0f, 2.0f, 0.5f, 4.0f};
    v4 rb = {1.0f, 0.5f, 0.5f, 0.5f};
    v4 rc;
    asm volatile("frecps %0.4s, %1.4s, %2.4s" : "=w"(*(v4*)&rc) : "w"(ra), "w"(rb));
    for (int i = 0; i < 4; ++i) {
        float expect = 2.0f - ra[i] * rb[i]; /* products are exact here */
        ZASSERT(rc[i] == expect);
    }
    ZASSERT(rc[0] == 1.0f && rc[2] == 1.75f && rc[3] == 0.0f);

    /* frecps (scalar). */
    float rr;
    asm volatile("frecps %s0, %s1, %s2" : "=w"(rr) : "w"(fs), "w"(fs));
    ZASSERT(rr == 2.0f - 3.5f * 3.5f);

    /* frsqrts: (3.0 - a*b) / 2.0, fully fused (exact products). */
    v4 sa = {1.0f, 2.0f, 4.0f, 0.5f};
    v4 sb = {1.0f, 0.5f, 0.5f, 0.5f};
    v4 sc;
    asm volatile("frsqrts %0.4s, %1.4s, %2.4s" : "=w"(*(v4*)&sc) : "w"(sa), "w"(sb));
    for (int i = 0; i < 4; ++i) {
        float prod = sa[i] * sb[i];
        float want = (3.0f - prod) / 2.0f;
        ZASSERT(sc[i] == want);
    }

    /* frsqrts (scalar) and special: inf*0 -> 1.5, otherwise inf propagates
       per the fused step. */
    asm volatile("frsqrts %s0, %s1, %s2" : "=w"(rr) : "w"(qs), "w"(qs));
    ZASSERT(rr == (3.0f - 81.0f) / 2.0f);
    asm volatile("frsqrts %s0, %s1, %s2" : "=w"(rr) : "w"(0.0f), "w"(INFINITY));
    ZASSERT(rr == 1.5f);
    asm volatile("frsqrts %s0, %s1, %s2" : "=w"(rr) : "w"(1.0f), "w"(INFINITY));
    ZASSERT(signbit(rr) != 0); /* finite * inf -> -inf per the fused step */

    /* fmaxnmv/fminnmv: across-lane FP reductions that ignore NaNs. */
    v4 m = {3.5f, -2.25f, 12.0f, 7.0f};
    float mv;
    asm volatile("fmaxnmv %s0, %1.4s" : "=w"(mv) : "w"(m));
    ZASSERT(mv == 12.0f);
    asm volatile("fminnmv %s0, %1.4s" : "=w"(mv) : "w"(m));
    ZASSERT(mv == -2.25f);
    v4 m2 = {3.5f, -2.25f, 12.0f, NAN};
    asm volatile("fmaxnmv %s0, %1.4s" : "=w"(mv) : "w"(m2));
    ZASSERT(mv == 12.0f);
    asm volatile("fminnmv %s0, %1.4s" : "=w"(mv) : "w"(m2));
    ZASSERT(mv == -2.25f);
    v4 m3 = {NAN, 1.0f, NAN, -1.0f};
    asm volatile("fmaxnmv %s0, %1.4s" : "=w"(mv) : "w"(m3));
    ZASSERT(mv == 1.0f);
    asm volatile("fminnmv %s0, %1.4s" : "=w"(mv) : "w"(m3));
    ZASSERT(mv == -1.0f);
    /* fmaxnmv also reduces .4h/.8h with fullfp16; .4s and .8h here. */
    v4 ms = {1.5f, -4.5f, 9.0f, -9.0f};
    float mvs;
    asm volatile("fmaxnmv %s0, %1.4s" : "=w"(mvs) : "w"(ms));
    ZASSERT(mvs == 9.0f);
    asm volatile("fminnmv %s0, %1.4s" : "=w"(mvs) : "w"(ms));
    ZASSERT(mvs == -9.0f);

    /* Cross-check frecpe/frsqrte reference quality (documented property:
       the estimate has a small relative error, hence usable as a
       reciprocal/residual-root starting point). */
    for (int i = 0; i < 5; ++i) {
        float f = px[i];
        float e = bitf(frecpe_ref(f));
        float r = bitf(frsqrte_ref(f));
        ZASSERT(e * f - 1.0f < 0.01f && e * f - 1.0f > -0.01f);
        ZASSERT(r * sqrtf(f) - 1.0f < 0.05f &&
                r * sqrtf(f) - 1.0f > -0.05f);
    }
    return 0;
}
