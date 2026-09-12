#include <stdfil.h>
#include <stdint.h>

/* FEAT_FCMA complex add and multiply-accumulate. fcadd is Vd, Vn, Vm, #rot;
   fcmla is Vd, Vn, Vm, #rot (tied accumulator destination, by-vector and
   by-element forms). The rotation operand is an immediate in
   {0, 90, 180, 270}. The .8h forms additionally need fullfp16, so the test
   gates on vector fp16 (HWCAP_ASIMDHP) and assembles with
   -march=armv8.2-a+fcma+fullfp16.

   Semantics (pairs of lanes [2e], [2e+1] are complex elements):
     fcadd #rot: d = a + rotate(b, rot)   (only #90 and #270 are legal)
     fcmla #rot: d = d + a * rotate(b, rot)  (all four rotations)
   where rotate((r,i), 0) = (r,i), rotate((r,i), 90) = (-i,r),
   rotate((r,i), 180) = (-r,-i), rotate((r,i), 270) = (i,-r). */

typedef float v4 __attribute__((vector_size(16)));
typedef __fp16 h8 __attribute__((vector_size(16)));

static float rotate(float re, float im, float rot, int which)
{
    /* returns the component of rotate((re,im), rot): which 0 = real part,
       1 = imaginary part. */
    switch ((int)rot) {
    case 0: return which == 0 ? re : im;
    case 90: return which == 0 ? -im : re;
    case 180: return which == 0 ? -re : -im;
    default: return which == 0 ? im : -re; /* 270 */
    }
}

static void check_fcadd(v4 a, v4 b, float rot)
{
    v4 d;
    if (rot == 90.0f)
        asm volatile("fcadd %0.4s, %1.4s, %2.4s, #90" : "=w"(d) : "w"(a), "w"(b));
    else
        asm volatile("fcadd %0.4s, %1.4s, %2.4s, #270" : "=w"(d) : "w"(a), "w"(b));
    for (int p = 0; p < 2; ++p) {
        ZASSERT(d[2 * p] == a[2 * p] + rotate(b[2 * p], b[2 * p + 1], rot, 0));
        ZASSERT(d[2 * p + 1] == a[2 * p + 1] + rotate(b[2 * p], b[2 * p + 1], rot, 1));
    }
}

int main(void)
{
    v4 a = {1.0f, 2.0f, 3.0f, 4.0f};
    v4 b = {5.0f, 6.0f, 7.0f, 8.0f};

    /* fcadd with both legal rotations. */
    check_fcadd(a, b, 90.0f);
    check_fcadd(a, b, 270.0f);
    v4 d;
    asm volatile("fcadd %0.4s, %1.4s, %2.4s, #90" : "=w"(d) : "w"(a), "w"(b));
    ZASSERT(d[0] == -5.0f && d[1] == 7.0f);
    asm volatile("fcadd %0.4s, %1.4s, %2.4s, #270" : "=w"(d) : "w"(a), "w"(b));
    ZASSERT(d[0] == 7.0f && d[1] == -3.0f);

    /* fcadd .8h (needs fullfp16). */
    h8 ha = {1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f};
    h8 hb = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    h8 hd;
    asm volatile("fcadd %0.8h, %1.8h, %2.8h, #90" : "=w"(*(v4*)&hd) : "w"(ha), "w"(hb));
    ZASSERT(hd[0] == 0.0f && hd[1] == 3.0f);
    ZASSERT(hd[2] == 2.0f && hd[3] == 5.0f);
    ZASSERT(hd[6] == 6.0f && hd[7] == 9.0f);

    /* fcmla (vector, tied): acc += a * rotate(b, rot). */
    v4 acc = {1.0f, 1.0f, 1.0f, 1.0f};
    asm volatile("fcmla %0.4s, %1.4s, %2.4s, #0" : "+w"(acc) : "w"(a), "w"(b));
    /* pair 0: acc0 += 1*5 = 5 -> 6; acc1 += 1*6 = 6 -> 7 */
    ZASSERT(acc[0] == 6.0f && acc[1] == 7.0f);
    /* pair 1: acc2 += 3*7 = 21 -> 22; acc3 += 3*8 = 24 -> 25 */
    ZASSERT(acc[2] == 22.0f && acc[3] == 25.0f);

    asm volatile("fcmla %0.4s, %1.4s, %2.4s, #90" : "+w"(acc) : "w"(a), "w"(b));
    /* pair 0: acc0 += 2*(-6) -> -6; acc1 += 2*5 -> 17 */
    ZASSERT(acc[0] == -6.0f && acc[1] == 17.0f);
    /* pair 1: acc2 += 4*(-8) -> -10; acc3 += 4*7 -> 53 */
    ZASSERT(acc[2] == -10.0f && acc[3] == 53.0f);

    asm volatile("fcmla %0.4s, %1.4s, %2.4s, #180" : "+w"(acc) : "w"(a), "w"(b));
    ZASSERT(acc[0] == -11.0f && acc[1] == 11.0f);
    ZASSERT(acc[2] == -31.0f && acc[3] == 29.0f);

    asm volatile("fcmla %0.4s, %1.4s, %2.4s, #270" : "+w"(acc) : "w"(a), "w"(b));
    ZASSERT(acc[0] == 1.0f && acc[1] == 1.0f);
    ZASSERT(acc[2] == 1.0f && acc[3] == 1.0f);

    /* fcmla (by element): Vm.s[index] selects a complex pair of b.
       #0 with index 1: acc[i] += a[i%2... ] per lane: even lanes get
       a[2e]*b[2], odd lanes a[2e]*b[3]. */
    v4 acc2 = {0.0f, 0.0f, 0.0f, 0.0f};
    asm volatile("fcmla %0.4s, %1.4s, %2.s[1], #0" : "+w"(acc2) : "w"(a), "w"(b));
    /* a = {1,2,3,4}, b pair 1 = {7,8} */
    ZASSERT(acc2[0] == 7.0f);  /* a0*b2 */
    ZASSERT(acc2[1] == 8.0f);  /* a0*b3 */
    ZASSERT(acc2[2] == 21.0f); /* a2*b2 */
    ZASSERT(acc2[3] == 24.0f); /* a2*b3 */

    /* fcmla .8h (needs fullfp16). */
    h8 hacc = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    h8 hc = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    asm volatile("fcmla %0.8h, %1.8h, %2.8h, #0" : "+w"(*(v4*)&hacc) : "w"(hacc), "w"(hc));
    for (int i = 0; i < 8; ++i)
        ZASSERT(hacc[i] == 2.0f);

    /* fcmla .8h by element .h[1]. */
    h8 hacc2 = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
    asm volatile("fcmla %0.8h, %1.8h, %2.h[1], #0" : "+w"(*(v4*)&hacc2) : "w"(ha), "w"(hb));
    /* element h[1] of hb is 1.0: even lanes get ha[2e]*1 */
    ZASSERT(hacc2[0] == 1.0f && hacc2[1] == 1.0f);
    ZASSERT(hacc2[2] == 3.0f && hacc2[3] == 3.0f);
    ZASSERT(hacc2[6] == 7.0f && hacc2[7] == 7.0f);
    return 0;
}
