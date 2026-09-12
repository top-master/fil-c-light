#include <stdfil.h>
#include <arm_neon.h>

int main(void)
{
    float32x4_t a = {1.0f, 2.0f, 3.0f, 4.0f};
    float32x4_t b = {0.5f, 0.5f, 0.5f, 0.5f};
    float32x4_t c;

    asm volatile("fadd %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 1.5f && c[1] == 2.5f && c[3] == 4.5f);

    asm volatile("fsub %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 0.5f && c[3] == 3.5f);

    asm volatile("fmul %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 0.5f && c[3] == 2.0f);

    asm volatile("fdiv %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 2.0f && c[3] == 8.0f);

    asm volatile("fabs %0.4s, %1.4s" : "=w"(c) : "w"(-a));
    ZASSERT(c[0] == 1.0f && c[3] == 4.0f);

    asm volatile("fneg %0.4s, %1.4s" : "=w"(c) : "w"(a));
    ZASSERT(c[0] == -1.0f && c[3] == -4.0f);

    asm volatile("fsqrt %0.4s, %1.4s" : "=w"(c) : "w"(a));
    ZASSERT(c[0] == 1.0f && c[1] == 1.41421356f && c[3] == 2.0f);

    asm volatile("fmax %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 1.0f && c[3] == 4.0f);

    asm volatile("fmin %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 0.5f);

    asm volatile("fmaxnm %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 1.0f);

    asm volatile("fminnm %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 0.5f);

    asm volatile("fabd %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 0.5f && c[3] == 3.5f);

    /* fmla with tied accumulator. */
    float32x4_t acc = {1.0f, 1.0f, 1.0f, 1.0f};
    asm volatile("fmla %0.4s, %1.4s, %2.4s" : "+w"(acc) : "w"(a), "w"(b));
    ZASSERT(acc[0] == 1.5f && acc[3] == 3.0f);

    float32x4_t acc2 = {2.0f, 2.0f, 2.0f, 2.0f};
    asm volatile("fmls %0.4s, %1.4s, %2.4s" : "+w"(acc2) : "w"(a), "w"(b));
    ZASSERT(acc2[0] == 1.5f && acc2[3] == 0.0f);

    /* Pairwise float ops. */
    asm volatile("faddp %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 3.0f && c[1] == 7.0f && c[2] == 1.0f && c[3] == 1.0f);

    asm volatile("fmaxp %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 2.0f && c[1] == 4.0f);

    asm volatile("fminp %0.4s, %1.4s, %2.4s" : "=w"(c) : "w"(a), "w"(b));
    ZASSERT(c[0] == 1.0f && c[1] == 3.0f);

    /* mov: vector register copy (alias of orr). */
    asm volatile("mov %0.16b, %1.16b" : "=w"(c) : "w"(a));
    ZASSERT(c[0] == 1.0f && c[3] == 4.0f);

    /* Half-float conversion round trip. */
    float32x4_t up;
    float16x4_t h = {1.5f, 2.5f, 3.5f, 4.5f};
    asm volatile("fcvtl %0.4s, %1.4h" : "=w"(up) : "w"(h));
    ZASSERT(up[0] == 1.5f && up[3] == 4.5f);
    float16x4_t hd;
    asm volatile("fcvtn %0.4h, %1.4s" : "=w"(hd) : "w"(up));
    float32x4_t up2;
    asm volatile("fcvtl %0.4s, %1.4h" : "=w"(up2) : "w"(hd));
    ZASSERT(up2[0] == 1.5f && up2[3] == 4.5f);

    /* Vector scvtf/fcvtzs. */
    int32x4_t iv = {4, 5, 6, 7};
    float32x4_t fv;
    asm volatile("scvtf %0.4s, %1.4s" : "=w"(fv) : "w"(iv));
    ZASSERT(fv[0] == 4.0f && fv[3] == 7.0f);
    int32x4_t back;
    asm volatile("fcvtzs %0.4s, %1.4s" : "=w"(back) : "w"(fv));
    ZASSERT(back[0] == 4 && back[3] == 7);

    /* Vector ucvtf on unsigned data. */
    uint32x4_t uv = {8, 9, 10, 11};
    float32x4_t uf;
    asm volatile("ucvtf %0.4s, %1.4s" : "=w"(uf) : "w"(uv));
    ZASSERT(uf[0] == 8.0f && uf[3] == 11.0f);
    return 0;
}
