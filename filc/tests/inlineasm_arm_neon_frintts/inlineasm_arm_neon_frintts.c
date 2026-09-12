#include <stdfil.h>
#include <stdint.h>
#include <math.h>

/* FEAT_FRINTTS: frint32z/frint32x/frint64z/frint64x. The z forms round
   toward zero; the x forms use FPCR.RMode (RNE by default). The result is
   forced into the 32-bit (or 64-bit) signed integer range; NaN, infinity
   and out-of-range sources produce the architecture's -infinity pattern.
   FRINTTS has no hwcap word of its own in the first hwcap register: it is
   HWCAP2_FRINT, checked by the needsFRINTTS probe.

   The -march=armv8.5-a flag enables FEAT_FRINTTS for the assembler (the
   upstream LLVM driver spells this extension "fptoint" internally and does
   not accept it as a -march modifier; armv8.5-a is the architecture level
   that includes it). */

typedef float v4 __attribute__((vector_size(16)));
typedef double v2 __attribute__((vector_size(16)));
typedef uint32_t u4 __attribute__((vector_size(16)));
typedef uint64_t u2 __attribute__((vector_size(16)));

static uint32_t bits32(float f)
{
    uint32_t r;
    __builtin_memcpy(&r, &f, 4);
    return r;
}

static uint64_t bits64(double f)
{
    uint64_t r;
    __builtin_memcpy(&r, &f, 8);
    return r;
}

int main(void)
{
    /* frint32z (scalar): truncation. */
    float r;
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(2.7f));
    ZASSERT(r == 2.0f);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(-2.7f));
    ZASSERT(r == -2.0f);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(2.5f));
    ZASSERT(r == 2.0f);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(-2.5f));
    ZASSERT(r == -2.0f);
    /* -0.4 truncates to -1 then increments back to zero with the sign of
       the source: the result is -0.0 (per FPZero(sign)). */
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(-0.4f));
    ZASSERT(r == 0.0f && signbit(r));

    /* frint32x (scalar): RNE. */
    asm volatile("frint32x %s0, %s1" : "=w"(r) : "w"(2.5f));
    ZASSERT(r == 2.0f);
    asm volatile("frint32x %s0, %s1" : "=w"(r) : "w"(3.5f));
    ZASSERT(r == 4.0f);
    asm volatile("frint32x %s0, %s1" : "=w"(r) : "w"(-2.5f));
    ZASSERT(r == -2.0f);
    asm volatile("frint32x %s0, %s1" : "=w"(r) : "w"(2.7f));
    ZASSERT(r == 3.0f);

    /* frint32z/x range forcing: sources outside int32 (and NaN/infinity)
       produce the saturated INT32_MIN pattern 0xcf000000. Exactly INT32_MIN
       itself stays representable. */
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(2147483648.0f));
    ZASSERT(bits32(r) == 0xcf000000u);
    asm volatile("frint32x %s0, %s1" : "=w"(r) : "w"(2147483648.0f));
    ZASSERT(bits32(r) == 0xcf000000u);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(-2147483648.0f));
    ZASSERT(r == -2147483648.0f);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(-2147483904.0f));
    ZASSERT(bits32(r) == 0xcf000000u);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"((float)NAN));
    ZASSERT(bits32(r) == 0xcf000000u);
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"((float)INFINITY));
    ZASSERT(bits32(r) == 0xcf000000u);
    asm volatile("frint32x %s0, %s1" : "=w"(r) : "w"(-(float)INFINITY));
    ZASSERT(bits32(r) == 0xcf000000u);

    /* frint64z/x (scalar, doubles). */
    double rd;
    asm volatile("frint64z %d0, %d1" : "=w"(rd) : "w"(1.5));
    ZASSERT(rd == 1.0);
    asm volatile("frint64x %d0, %d1" : "=w"(rd) : "w"(1.5));
    ZASSERT(rd == 2.0);
    asm volatile("frint64x %d0, %d1" : "=w"(rd) : "w"(2.5));
    ZASSERT(rd == 2.0);
    asm volatile("frint64z %d0, %d1" : "=w"(rd) : "w"(-1.5));
    ZASSERT(rd == -1.0);
    /* 1e18 fits in int64. */
    asm volatile("frint64z %d0, %d1" : "=w"(rd) : "w"(1e18));
    ZASSERT(rd == 1e18);
    /* 2^63 does not; the forced result is the INT64_MIN pattern. */
    asm volatile("frint64z %d0, %d1" : "=w"(rd) : "w"(9.3e18));
    ZASSERT(bits64(rd) == 0xc3e0000000000000ull);
    asm volatile("frint64x %d0, %d1" : "=w"(rd) : "w"((double)NAN));
    ZASSERT(bits64(rd) == 0xc3e0000000000000ull);

    /* Vector forms: .4s and .2d. */
    v4 a = {2.7f, -2.7f, 2.5f, 2147483648.0f};
    u4 c;
    asm volatile("frint32z %0.4s, %1.4s" : "=w"(c) : "w"(a));
    ZASSERT(c[0] == bits32(2.0f));
    ZASSERT(c[1] == bits32(-2.0f));
    ZASSERT(c[2] == bits32(2.0f));
    ZASSERT(c[3] == 0xcf000000u);

    asm volatile("frint32x %0.4s, %1.4s" : "=w"(c) : "w"(a));
    ZASSERT(c[0] == bits32(3.0f));
    ZASSERT(c[1] == bits32(-3.0f));
    ZASSERT(c[2] == bits32(2.0f));
    ZASSERT(c[3] == 0xcf000000u);

    v2 da = {1.5, -1.5};
    v2 dc;
    asm volatile("frint64z %0.2d, %1.2d" : "=w"(dc) : "w"(da));
    ZASSERT(dc[0] == 1.0 && dc[1] == -1.0);
    asm volatile("frint64x %0.2d, %1.2d" : "=w"(dc) : "w"(da));
    ZASSERT(dc[0] == 2.0 && dc[1] == -2.0);

    /* frint32z keeps -0.0 for a -0.0 source. */
    asm volatile("frint32z %s0, %s1" : "=w"(r) : "w"(-0.0f));
    ZASSERT(r == 0.0f && signbit(r));
    return 0;
}
