#include <stdfil.h>
#include <stdint.h>
#include <arm_neon.h>

/* FEAT_FHM (fp16fml) mixed-precision MLA/MLS and FEAT_FP16 widening/narrowing
   conversions. fmlal/fmlal2/fmlsl/fmlsl2 accumulate into their destination
   (RMW), expressed with a tied "+w" output. The "2" forms use the high half
   of the source registers. Needs vector fp16 (HWCAP_ASIMDHP) at runtime and
   -march=armv8.2-a+fp16fml (which implies fullfp16) for the assembler.

   Note on spellings: LLVM/binutils spell the fmlal family with .2h/.4h
   source arrangements (the number of lanes consumed), where the ARM ARM
   writes .8h for the same 128-bit forms. */

typedef float v4 __attribute__((vector_size(16)));
typedef __fp16 h8 __attribute__((vector_size(16)));
typedef uint16_t u8 __attribute__((vector_size(16)));

static uint16_t bits16(__fp16 f)
{
    uint16_t r;
    __builtin_memcpy(&r, &f, 2);
    return r;
}

int main(void)
{
    /* fcvtl: widen the low four halves to singles, then fcvtn: narrow back.
       Round trip must reproduce the original bit patterns exactly. */
    h8 ha = {1.0f, 2.0f, -0.5f, 100.25f, 5.0f, 6.0f, 7.0f, 8.0f};
    v4 w;
    asm volatile("fcvtl %0.4s, %1.4h" : "=w"(w) : "w"(ha));
    ZASSERT(w[0] == 1.0f && w[1] == 2.0f && w[2] == -0.5f && w[3] == 100.25f);

    h8 hb;
    asm volatile("fcvtn %0.4h, %1.4s" : "=w"(*(v4*)&hb) : "w"(w));
    for (int i = 0; i < 4; ++i)
        ZASSERT(bits16(hb[i]) == bits16(ha[i]));

    /* fcvtl2/fcvtn2: same, for the high half of the source. */
    asm volatile("fcvtl2 %0.4s, %1.8h" : "=w"(w) : "w"(ha));
    ZASSERT(w[0] == 5.0f && w[1] == 6.0f && w[2] == 7.0f && w[3] == 8.0f);
    h8 hc = {9.0f, 9.0f, 9.0f, 9.0f, 9.0f, 9.0f, 9.0f, 9.0f};
    asm volatile("fcvtn %0.4h, %1.4s" : "=w"(*(v4*)&hc) : "w"(w));
    asm volatile("fcvtn2 %0.8h, %1.4s" : "+w"(*(v4*)&hc) : "w"(w));
    for (int i = 0; i < 4; ++i)
        ZASSERT(bits16(hc[i]) == bits16(ha[4 + i]));
    for (int i = 4; i < 8; ++i)
        ZASSERT(bits16(hc[i]) == bits16(ha[4 + i - 4]));

    /* fmlal: acc += f32(lo(a)) * f32(lo(b)). */
    v4 acc = {1.0f, 1.0f, 1.0f, 1.0f};
    h8 ma = {1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f};
    h8 mb = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    asm volatile("fmlal %0.4s, %1.4h, %2.4h" : "+w"(acc) : "w"(ma), "w"(mb));
    ZASSERT(acc[0] == 2.0f && acc[1] == 3.0f && acc[2] == 4.0f && acc[3] == 5.0f);

    /* fmlal2: acc += f32(hi(a)) * f32(hi(b)). */
    asm volatile("fmlal2 %0.4s, %1.4h, %2.4h" : "+w"(acc) : "w"(ma), "w"(mb));
    ZASSERT(acc[0] == 7.0f && acc[1] == 9.0f && acc[2] == 11.0f && acc[3] == 13.0f);

    /* fmlsl/fmlsl2: acc -= ... */
    v4 acc2 = {10.0f, 10.0f, 10.0f, 10.0f};
    asm volatile("fmlsl %0.4s, %1.4h, %2.4h" : "+w"(acc2) : "w"(ma), "w"(mb));
    ZASSERT(acc2[0] == 9.0f && acc2[1] == 8.0f && acc2[2] == 7.0f && acc2[3] == 6.0f);
    asm volatile("fmlsl2 %0.4s, %1.4h, %2.4h" : "+w"(acc2) : "w"(ma), "w"(mb));
    ZASSERT(acc2[0] == 4.0f && acc2[1] == 2.0f && acc2[2] == 0.0f && acc2[3] == -2.0f);

    /* By-element forms: the element index selects a half pair. */
    v4 acc3 = {0.0f, 0.0f, 0.0f, 0.0f};
    asm volatile("fmlal %0.4s, %1.4h, %2.h[1]" : "+w"(acc3) : "w"(ma), "w"(mb));
    /* element h[1] of mb is 1.0, so this is just lo(a) */
    ZASSERT(acc3[0] == 1.0f && acc3[3] == 4.0f);

    /* Half-precision values that are not exactly representable in fp16
       round trip through fcvtl/fcvtn preserving bits (fcvtn rounds to
       nearest even, and these are already fp16-exact). */
    h8 hd = {65504.0f /* max fp16 */, -65504.0f, 6.1035156e-5f /* 2^-14 */, -6.1035156e-5f,
             1.0009765625f, -1.0009765625f, 0.33325195f, -0.33325195f};
    asm volatile("fcvtl %0.4s, %1.4h" : "=w"(w) : "w"(hd));
    asm volatile("fcvtn %0.4h, %1.4s" : "=w"(*(v4*)&hd) : "w"(w));
    ZASSERT(bits16(hd[0]) == 0x7bffu);
    ZASSERT(bits16(hd[1]) == 0xfbffu);
    ZASSERT(bits16(hd[2]) == 0x0400u);
    ZASSERT(bits16(hd[3]) == 0x8400u);

    /* Widening arithmetic on the widened values matches fp32 arithmetic. */
    v4 ws;
    asm volatile("fcvtl %0.4s, %1.4h" : "=w"(ws) : "w"(hd));
    ZASSERT(ws[0] == 65504.0f && ws[2] == 6.1035156e-5f);

    /* fmla on .8h (fullfp16 vector arithmetic) still accumulates in fp16. */
    h8 fa = {1.5f, 1.5f, 1.5f, 1.5f, 1.5f, 1.5f, 1.5f, 1.5f};
    h8 fb = {2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f};
    h8 facc = {1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f};
    asm volatile("fmla %0.8h, %1.8h, %2.8h" : "+w"(*(v4*)&facc) : "w"(fa), "w"(fb));
    for (int i = 0; i < 8; ++i)
        ZASSERT(bits16(facc[i]) == bits16((__fp16)4.0f));
    return 0;
}
