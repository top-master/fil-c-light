#include <stdfil.h>

int main(void)
{
    double a = 6.0, b = 4.0, r;

    asm volatile("fadd %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 10.0);

    asm volatile("fsub %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 2.0);

    asm volatile("fmul %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 24.0);

    asm volatile("fdiv %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 1.5);

    asm volatile("fabs %d0, %d1" : "=w"(r) : "w"(-3.5));
    ZASSERT(r == 3.5);

    asm volatile("fneg %d0, %d1" : "=w"(r) : "w"(3.5));
    ZASSERT(r == -3.5);

    asm volatile("fsqrt %d0, %d1" : "=w"(r) : "w"(2.25));
    ZASSERT(r == 1.5);

    asm volatile("fmax %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 6.0);

    asm volatile("fmin %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 4.0);

    asm volatile("fmaxnm %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 6.0);

    asm volatile("fminnm %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 4.0);

    asm volatile("fmov %d0, %d1" : "=w"(r) : "w"(a));
    ZASSERT(r == 6.0);

    /* FP immediate. */
    float rf;
    asm volatile("fmov %s0, #1.0" : "=w"(rf));
    ZASSERT(rf == 1.0f);

    asm volatile("fmulx %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 24.0);

    asm volatile("fabd %d0, %d1, %d2" : "=w"(r) : "w"(a), "w"(b));
    ZASSERT(r == 2.0);

    /* Fused multiply-add forms. */
    asm volatile("fmadd %d0, %d1, %d2, %d3" : "=w"(r) : "w"(a), "w"(b), "w"(1.5));
    ZASSERT(r == 25.5);

    asm volatile("fmsub %d0, %d1, %d2, %d3" : "=w"(r) : "w"(a), "w"(b), "w"(1.5));
    ZASSERT(r == -22.5);

    asm volatile("fnmadd %d0, %d1, %d2, %d3" : "=w"(r) : "w"(a), "w"(b), "w"(1.5));
    ZASSERT(r == -25.5); /* -a - a*b */

    asm volatile("fnmsub %d0, %d1, %d2, %d3" : "=w"(r) : "w"(a), "w"(b), "w"(1.5));
    ZASSERT(r == 22.5); /* a*b - a */

    /* Single-precision. */
    float fa = 1.5f, fb = 2.25f, fr;
    asm volatile("fadd %s0, %s1, %s2" : "=w"(fr) : "w"(fa), "w"(fb));
    ZASSERT(fr == 3.75f);

    asm volatile("fsub %s0, %s1, %s2" : "=w"(fr) : "w"(fa), "w"(fb));
    ZASSERT(fr == -0.75f);

    asm volatile("fmul %s0, %s1, %s2" : "=w"(fr) : "w"(fa), "w"(fb));
    ZASSERT(fr == 3.375f);

    asm volatile("fdiv %s0, %s1, %s2" : "=w"(fr) : "w"(3.0f), "w"(4.0f));
    ZASSERT(fr == 0.75f);

    asm volatile("fabs %s0, %s1" : "=w"(fr) : "w"(-2.5f));
    ZASSERT(fr == 2.5f);

    asm volatile("fneg %s0, %s1" : "=w"(fr) : "w"(2.5f));
    ZASSERT(fr == -2.5f);

    asm volatile("fsqrt %s0, %s1" : "=w"(fr) : "w"(4.0f));
    ZASSERT(fr == 2.0f);

    asm volatile("fmax %s0, %s1, %s2" : "=w"(fr) : "w"(fa), "w"(fb));
    ZASSERT(fr == 2.25f);

    asm volatile("fmin %s0, %s1, %s2" : "=w"(fr) : "w"(fa), "w"(fb));
    ZASSERT(fr == 1.5f);

    asm volatile("fmadd %s0, %s1, %s2, %s3" : "=w"(fr) : "w"(fa), "w"(fb), "w"(0.5f));
    ZASSERT(fr == 3.875f);

    /* Tied "+w" accumulate. */
    double acc = 1.0;
    asm volatile("fadd %d0, %d0, %d1" : "+w"(acc) : "w"(a));
    ZASSERT(acc == 7.0);
    return 0;
}
