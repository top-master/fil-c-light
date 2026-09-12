#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    int32x4_t a = {1, 2, 3, 4};
    int32x4_t b = {10, 20, 30, 40};
    int32x4_t r;

    /* addp: pairwise add of two vectors. */
    asm volatile("addp %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0] == 3 && r[1] == 7 && r[2] == 30 && r[3] == 70);

    /* addp: pair of elements (scalar two-operand form, 64-bit only). */
    int64x2_t pair = {5, 7};
    long p2;
    asm volatile("addp %d0, %1.2d" : "=w"(p2) : "w"(pair));
    ZASSERT(p2 == 12);

    float32x4_t fpair = {1.5f, 2.25f, 0.0f, 0.0f};
    float ffp;
    asm volatile("faddp %s0, %1.2s" : "=w"(ffp) : "w"(fpair));
    ZASSERT(ffp == 3.75f);

    /* Reductions across the vector. */
    int red;
    asm volatile("addv %s0, %1.4s" : "=w"(red) : "w"(b));
    ZASSERT(red == 100);

    int16x8_t ha = {1, 2, 3, 4, 5, 6, 7, 8};
    short hred;
    asm volatile("addv %h0, %1.8h" : "=w"(hred) : "w"(ha));
    ZASSERT(hred == 36);

    int mx;
    asm volatile("smaxv %s0, %1.4s" : "=w"(mx) : "w"(b));
    ZASSERT(mx == 40);

    asm volatile("sminv %s0, %1.4s" : "=w"(mx) : "w"(b));
    ZASSERT(mx == 10);

    uint32x4_t ub = {100, 200, 5, 40};
    unsigned umx;
    asm volatile("umaxv %s0, %1.4s" : "=w"(umx) : "w"(ub));
    ZASSERT(umx == 200);

    asm volatile("uminv %s0, %1.4s" : "=w"(umx) : "w"(ub));
    ZASSERT(umx == 5);

    /* Pairwise min/max across two vectors. */
    asm volatile("smaxp %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0] == 2 && r[1] == 4 && r[2] == 20 && r[3] == 40);

    asm volatile("sminp %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0] == 1 && r[1] == 3 && r[2] == 10 && r[3] == 30);

    asm volatile("umaxp %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0] == 2 && r[3] == 40);

    asm volatile("uminp %0.4s, %1.4s, %2.4s" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r[0] == 1 && r[3] == 30);

    /* bsl/bit/bif with tied destination. */
    int32x4_t m = {-1, -1, 0, 0}, x = {10, 20, 30, 40}, y = {1, 2, 3, 4}, d;
    d = m;
    asm volatile("bsl %0.16b, %1.16b, %2.16b" : "+w"(d) : "w"(x), "w"(y));
    ZASSERT(d[0] == 10 && d[1] == 20 && d[2] == 3 && d[3] == 4);

    int32x4_t m2 = {-1, -1, 0, 0}, base = {9, 9, 9, 9};
    d = base;
    asm volatile("bit %0.16b, %1.16b, %2.16b" : "+w"(d) : "w"(x), "w"(m2));
    ZASSERT(d[0] == 10 && d[1] == 20 && d[2] == 9 && d[3] == 9);

    d = base;
    asm volatile("bif %0.16b, %1.16b, %2.16b" : "+w"(d) : "w"(x), "w"(m2));
    ZASSERT(d[0] == 9 && d[1] == 9 && d[2] == 30 && d[3] == 40);

    /* cnt/abs/neg/clz on vectors. */
    int16x8_t hx = {1, -2, 3, -4, 5, -6, 7, -8};
    int16x8_t hr;
    asm volatile("abs %0.8h, %1.8h" : "=w"(hr) : "w"(hx));
    ZASSERT(hr[0] == 1 && hr[1] == 2 && hr[7] == 8);

    asm volatile("neg %0.8h, %1.8h" : "=w"(hr) : "w"(hx));
    ZASSERT(hr[0] == -1 && hr[1] == 2 && hr[7] == 8);

    uint8x16_t bytes = {0, 255, 128, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    uint8x16_t cr;
    asm volatile("cnt %0.16b, %1.16b" : "=w"(cr) : "w"(bytes));
    ZASSERT(cr[0] == 0 && cr[1] == 8 && cr[2] == 1 && cr[3] == 1);

    int32x4_t cz;
    asm volatile("clz %0.4s, %1.4s" : "=w"(cz) : "w"(b));
    ZASSERT(cz[0] == 28 && cz[3] == 26);
    return 0;
}
