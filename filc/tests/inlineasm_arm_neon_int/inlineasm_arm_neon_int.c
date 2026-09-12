#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    int32x4_t a = {1, 2, 3, 4};
    int32x4_t b = {10, 20, 30, 40};
    int32x4_t c;

    asm volatile("add %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 11 && c[1] == 22 && c[2] == 33 && c[3] == 44);

    asm volatile("sub %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(b), "w"(a));
    ZASSERT(c[0] == 9 && c[3] == 36);

    asm volatile("mul %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 10 && c[3] == 160);

    /* 16-bit lanes. */
    int16x8_t ha = {1, 2, 3, 4, 5, 6, 7, 8};
    int16x8_t hb = {2, 2, 2, 2, 2, 2, 2, 2};
    int16x8_t hc;
    asm volatile("mul %0.8h, %1.8h, %2.8h" : "=w"(hc) : "w"(ha), "w"(hb));
    ZASSERT(hc[0] == 2 && hc[7] == 16);

    asm volatile("add %0.8h, %1.8h, %2.8h" : "=w"(hc) : "w"(ha), "w"(hb));
    ZASSERT(hc[0] == 3 && hc[7] == 10);

    /* Bitwise ops on 16b views. */
    int32x4_t ba = {0xF0F0F0F0, 0xFF00FF00, 0xAAAAAAAA, 0x0F0F0F0F};
    int32x4_t bb = {0x0F0F0F0F, 0x00FF00FF, 0x55555555, 0xF0F0F0F0};
    int32x4_t bc;
    asm volatile("and %0.16b, %1.16b, %2.16b" : "=w"(bc) : "w"(ba), "w"(bb));
    ZASSERT(bc[0] == 0 && bc[1] == 0 && bc[2] == 0 && bc[3] == 0);

    asm volatile("orr %0.16b, %1.16b, %2.16b" : "=w"(bc) : "w"(ba), "w"(bb));
    ZASSERT((unsigned)bc[0] == 0xFFFFFFFFU && (unsigned)bc[1] == 0xFFFFFFFFU);

    asm volatile("eor %0.16b, %1.16b, %2.16b" : "=w"(bc) : "w"(ba), "w"(bb));
    ZASSERT((unsigned)bc[2] == 0xFFFFFFFFU && (unsigned)bc[3] == 0xFFFFFFFFU);

    asm volatile("bic %0.16b, %1.16b, %2.16b" : "=w"(bc) : "w"(ba), "w"(bb));
    ZASSERT((unsigned)bc[0] == 0xF0F0F0F0U && (unsigned)bc[1] == 0xFF00FF00U);

    asm volatile("orn %0.16b, %1.16b, %2.16b" : "=w"(bc) : "w"(bb), "w"(ba));
    ZASSERT((unsigned)bc[0] == 0x0F0F0F0FU);

    /* umov: lane to general register. */
    unsigned long lane;
    /* c now holds a * b = {10, 40, 90, 160}. */
    asm volatile("umov %w0, %1.s[2]" : "=r"(lane) : "w"(c));
    ZASSERT(lane == 90);

    long slane;
    asm volatile("smov %x0, %1.b[0]" : "=r"(slane) : "w"(hb));
    ZASSERT(slane == 2);

    /* ins: general register to lane (tied). */
    asm volatile("ins %0.s[1], %w1" : "+w"(c) : "r"(77));
    ZASSERT(c[0] == 10 && c[1] == 77 && c[2] == 90 && c[3] == 160);

    int32x4_t ci = {5, 5, 5, 5};
    asm volatile("ins %0.b[0], %1.b[0]" : "+w"(ci) : "w"(ha));
    ZASSERT(ci[0] == 1 && ci[1] == 5);

    /* dup: broadcast scalar and lane. */
    int32x4_t dupv;
    asm volatile("dup %0.4s, %w1" : "=w"(dupv) : "r"(42));
    ZASSERT(dupv[0] == 42 && dupv[3] == 42);

    asm volatile("dup %0.4s, %1.s[0]" : "=w"(dupv) : "w"(b));
    ZASSERT(dupv[0] == 10 && dupv[3] == 10);

    /* ext: extract across the pair of vectors. */
    int32x4_t e;
    asm volatile("ext %0.16b, %1.16b, %2.16b, #4" : "=w"(e) : "w"(a), "w"(b));
    ZASSERT(e[0] == 2 && e[1] == 3 && e[2] == 4 && e[3] == 10);

    /* zip/uzp/trn. */
    int32x4_t va = {0, 1, 2, 3}, vb = {4, 5, 6, 7}, vr;
    asm volatile("zip1 %0.4s, %1.4s, %2.4s" : "=w"(vr) : "w"(va), "w"(vb));
    ZASSERT(vr[0] == 0 && vr[1] == 4 && vr[2] == 1 && vr[3] == 5);

    asm volatile("zip2 %0.4s, %1.4s, %2.4s" : "=w"(vr) : "w"(va), "w"(vb));
    ZASSERT(vr[0] == 2 && vr[1] == 6 && vr[2] == 3 && vr[3] == 7);

    asm volatile("uzp1 %0.4s, %1.4s, %2.4s" : "=w"(vr) : "w"(va), "w"(vb));
    ZASSERT(vr[0] == 0 && vr[1] == 2 && vr[2] == 4 && vr[3] == 6);

    asm volatile("uzp2 %0.4s, %1.4s, %2.4s" : "=w"(vr) : "w"(va), "w"(vb));
    ZASSERT(vr[0] == 1 && vr[1] == 3 && vr[2] == 5 && vr[3] == 7);

    asm volatile("trn1 %0.4s, %1.4s, %2.4s" : "=w"(vr) : "w"(va), "w"(vb));
    ZASSERT(vr[0] == 0 && vr[1] == 4 && vr[2] == 2 && vr[3] == 6);

    asm volatile("trn2 %0.4s, %1.4s, %2.4s" : "=w"(vr) : "w"(va), "w"(vb));
    ZASSERT(vr[0] == 1 && vr[1] == 5 && vr[2] == 3 && vr[3] == 7);
    return 0;
}
