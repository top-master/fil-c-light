#include <stdfil.h>
#include <arm_neon.h>
#include <stdint.h>

/* Saturating helpers, matching the ARM SignedSatQ/UnsignedSatQ semantics. */
static int32_t sat32(int64_t x)
{
    if (x > INT32_MAX) return INT32_MAX;
    if (x < INT32_MIN) return INT32_MIN;
    return (int32_t)x;
}

static int16_t sat16(int32_t x)
{
    if (x > INT16_MAX) return INT16_MAX;
    if (x < INT16_MIN) return INT16_MIN;
    return (int16_t)x;
}

static int8_t sat8(int32_t x)
{
    if (x > INT8_MAX) return INT8_MAX;
    if (x < INT8_MIN) return INT8_MIN;
    return (int8_t)x;
}

int main(void)
{
    /* sqadd: signed saturating add, 32-bit lanes. */
    int32x4_t a = {100, INT32_MAX, INT32_MIN, 7};
    int32x4_t b = {23, 1, -1, -7};
    int32x4_t c;
    asm volatile("sqadd %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 123);
    ZASSERT(c[1] == INT32_MAX); /* saturates */
    ZASSERT(c[2] == INT32_MIN); /* saturates */
    ZASSERT(c[3] == 0);

    /* uqadd: unsigned saturating add, 32-bit lanes. */
    uint32x4_t ua = {100, 0xFFFFFFFFU, 5, 0};
    uint32x4_t ub = {23, 1, 6, 9};
    uint32x4_t uc;
    asm volatile("uqadd %0.4s, %1.4s, %2.4s" : "=w"(uc) : "w"(ua), "w"(ub));
    ZASSERT(uc[0] == 123);
    ZASSERT(uc[1] == 0xFFFFFFFFU); /* saturates */
    ZASSERT(uc[2] == 11);
    ZASSERT(uc[3] == 9);

    /* sqsub: signed saturating subtract, 16-bit lanes. */
    int16x8_t ha = {100, INT16_MAX, INT16_MIN, 5, 8, 2, 3, 4};
    int16x8_t hb = {58, -1, 1, 5, 1, 2, 3, 4};
    int16x8_t hc;
    asm volatile("sqsub %0.8h, %1.8h, %2.8h" : "=w"(hc) : "w"(ha), "w"(hb));
    ZASSERT(hc[0] == 42);
    ZASSERT(hc[1] == INT16_MAX); /* INT16_MAX - (-1) saturates */
    ZASSERT(hc[2] == INT16_MIN); /* INT16_MIN - 1 saturates */
    ZASSERT(hc[3] == 0);
    ZASSERT(hc[6] == 0 && hc[7] == 0);

    /* uqsub: unsigned saturating subtract, 8-bit lanes. */
    uint8x16_t ba = {200, 0, 255, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13};
    uint8x16_t bb = {58, 1, 100, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    uint8x16_t bc;
    asm volatile("uqsub %0.16b, %1.16b, %2.16b" : "=w"(bc) : "w"(ba), "w"(bb));
    ZASSERT(bc[0] == 142);
    ZASSERT(bc[1] == 0); /* 0 - 1 saturates to 0 */
    ZASSERT(bc[2] == 155);
    ZASSERT(bc[3] == 0);
    ZASSERT(bc[15] == 12);

    /* suqadd: signed saturating accumulate of unsigned value (2-op, tied). */
    int32x4_t acc = {100, 0, INT32_MAX - 5, INT32_MIN};
    uint32x4_t us = {50, 1, 100, 1};
    asm volatile("suqadd %0.4s, %1.4s" : "+w"(acc) : "w"(us));
    ZASSERT(acc[0] == 150);
    ZASSERT(acc[1] == 1);
    ZASSERT(acc[2] == INT32_MAX); /* saturates */
    ZASSERT(acc[3] == INT32_MIN + 1);

    /* suqadd on 16-bit lanes. */
    int16x8_t hacc = {5, INT16_MAX - 2, INT16_MIN, -1};
    uint16x8_t hus = {10, 100, 5, 0};
    asm volatile("suqadd %0.8h, %1.8h" : "+w"(hacc) : "w"(hus));
    ZASSERT(hacc[0] == 15);
    ZASSERT(hacc[1] == INT16_MAX); /* saturates */
    ZASSERT(hacc[2] == INT16_MIN + 5);
    ZASSERT(hacc[3] == -1);

    /* usqadd: unsigned saturating accumulate of signed value (2-op, tied).
       The signed source may drive the accumulator below zero, which
       saturates to zero. */
    uint32x4_t uacc = {100, 0, 0xFFFFFFFFU, 50};
    int32x4_t ss = {-30, -1, 1, 25};
    asm volatile("usqadd %0.4s, %1.4s" : "+w"(uacc) : "w"(ss));
    ZASSERT(uacc[0] == 70);
    ZASSERT(uacc[1] == 0); /* saturates at zero */
    ZASSERT(uacc[2] == 0xFFFFFFFFU); /* 0xFFFFFFFF + 1 saturates at 2^32-1 */
    ZASSERT(uacc[3] == 75);

    /* usqadd on 16-bit lanes. */
    uint16x8_t huacc = {10, 0, 3, 0xFFFFU, 7, 1, 2, 3};
    int16x8_t hss = {-20, -1, 4, 1, -7, 2, 3, 4};
    asm volatile("usqadd %0.8h, %1.8h" : "+w"(huacc) : "w"(hss));
    ZASSERT(huacc[0] == 0); /* saturates at zero */
    ZASSERT(huacc[1] == 0);
    ZASSERT(huacc[2] == 7);
    ZASSERT(huacc[3] == 0xFFFFU); /* 0xFFFF + 1 saturates */
    ZASSERT(huacc[4] == 0);
    ZASSERT(huacc[7] == 7);

    /* sqabs: saturating absolute value. */
    int16x8_t na = {-7, INT16_MIN, 0, 42, -1, -2, -3, -4};
    int16x8_t nr;
    asm volatile("sqabs %0.8h, %1.8h" : "=w"(nr) : "w"(na));
    ZASSERT(nr[0] == 7);
    ZASSERT(nr[1] == INT16_MAX); /* saturates */
    ZASSERT(nr[2] == 0);
    ZASSERT(nr[3] == 42);

    /* sqneg: saturating negate. */
    int32x4_t pa = {7, INT32_MIN, 0, -42};
    int32x4_t pr;
    asm volatile("sqneg %0.4s, %1.4s" : "=w"(pr) : "w"(pa));
    ZASSERT(pr[0] == -7);
    ZASSERT(pr[1] == INT32_MAX); /* saturates */
    ZASSERT(pr[2] == 0);
    ZASSERT(pr[3] == 42);

    /* Scalar (1-element) forms of the saturating ops. */
    int32_t sc;
    asm volatile("sqadd %s0, %s1, %s2" : "=w"(sc) : "w"(INT32_MAX), "w"(1));
    ZASSERT(sc == INT32_MAX);

    uint32_t usc;
    asm volatile("uqsub %s0, %s1, %s2" : "=w"(usc) : "w"(0U), "w"(1U));
    ZASSERT(usc == 0U);

    /* Cross-check a whole .4s sqadd against the C saturating helper. */
    int32x4_t xa = {2147483000, -2147483000, 12345, -1};
    int32x4_t xb = {1000, -1000, -54321, -2};
    int32x4_t xc;
    asm volatile("sqadd %0.4s, %1.4s, %2.4s" : "=w"(xc) : "w"(xa), "w"(xb));
    for (int i = 0; i < 4; ++i) {
        int32_t want = sat32((int64_t)xa[i] + (int64_t)xb[i]);
        ZASSERT(xc[i] == want);
    }
    return 0;
}
