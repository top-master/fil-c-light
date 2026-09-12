#include <stdfil.h>
#include <stdint.h>

/* FEAT_BF16: bfcvt (scalar), bfcvtn/bfcvtn2 (vector narrowing), and bfdot
   (bfloat16 dot product with fp32 accumulator, vector and by-element).
   bf16 results live in 16-bit lanes as raw bf16 bit patterns; every input
   below is exactly representable in bf16 so the arithmetic comparisons are
   exact. */

typedef float v4 __attribute__((vector_size(16)));
typedef uint32_t u4 __attribute__((vector_size(16)));
typedef uint16_t u8v __attribute__((vector_size(16)));

static uint32_t bits32(float f)
{
    uint32_t r;
    __builtin_memcpy(&r, &f, 4);
    return r;
}

static float f32(uint32_t x)
{
    float r;
    __builtin_memcpy(&r, &x, 4);
    return r;
}

/* bf16 (RNE) of a float: the top 16 bits of the fp32 pattern, with
   round-to-nearest-even on the dropped 15 bits. All test inputs are
   bf16-exact so the rounding never fires, but implement it anyway. */
static uint16_t bf16_rne(float f)
{
    uint32_t x = bits32(f);
    uint32_t lsb = (x >> 16) & 1u;
    uint32_t rounded = x + 0x7fffu + lsb;
    return (uint16_t)(rounded >> 16);
}

int main(void)
{
    /* bfcvt (scalar): f32 -> bf16. Uses the %h/%s asm operand modifiers to
       name the 16/32-bit scalar views of the allocated v-registers. */
    float src = 1.5f;
    uint16_t dst;
    asm volatile("bfcvt %h0, %s1" : "=w"(dst) : "w"(src));
    ZASSERT(dst == 0x3fc0u); /* bf16 of 1.5 */

    float src2 = -2.5f;
    asm volatile("bfcvt %h0, %s1" : "=w"(dst) : "w"(src2));
    ZASSERT(dst == 0xc020u);

    float src3 = 65504.0f; /* rounds up to bf16 0x4780 (65536) */
    asm volatile("bfcvt %h0, %s1" : "=w"(dst) : "w"(src3));
    ZASSERT(dst == bf16_rne(src3));
    ZASSERT(dst == 0x4780u);

    /* bfcvtn: narrow four fp32 lanes to four bf16 lanes. */
    v4 a = {1.0f, 2.0f, 3.0f, 4.0f};
    u8v h;
    asm volatile("bfcvtn %0.4h, %1.4s" : "=w"(*(u4*)&h) : "w"(a));
    ZASSERT(h[0] == bf16_rne(1.0f));
    ZASSERT(h[1] == bf16_rne(2.0f));
    ZASSERT(h[2] == bf16_rne(3.0f));
    ZASSERT(h[3] == bf16_rne(4.0f));
    ZASSERT(h[0] == 0x3f80u && h[3] == 0x4080u);

    /* bfcvtn2: narrow into the high half of the destination. */
    v4 b = {5.0f, 6.0f, 7.0f, 8.0f};
    u8v h2 = {1, 1, 1, 1, 1, 1, 1, 1};
    asm volatile("bfcvtn %0.4h, %1.4s" : "=w"(*(u4*)&h2) : "w"(a));
    asm volatile("bfcvtn2 %0.8h, %1.4s" : "+w"(*(u4*)&h2) : "w"(b));
    ZASSERT(h2[0] == 0x3f80u && h2[3] == 0x4080u);
    ZASSERT(h2[4] == bf16_rne(5.0f) && h2[5] == bf16_rne(6.0f));
    ZASSERT(h2[6] == bf16_rne(7.0f) && h2[7] == bf16_rne(8.0f));

    /* bfdot (vector): dest.s[i] += bf16(a.h[2i])*bf16(b.h[2i])
                                 + bf16(a.h[2i+1])*bf16(b.h[2i+1]). */
    u8v da = {0x3f80u, 0x4000u, /* 1.0, 2.0 */
              0x4040u, 0x4080u, /* 3.0, 4.0 */
              0x40a0u, 0x40c0u, /* 5.0, 6.0 */
              0x40e0u, 0x4100u}; /* 7.0, 8.0 */
    u8v db = {0x4000u, 0x4000u, /* 2, 2 */
              0x4000u, 0x4000u,
              0x4000u, 0x4000u,
              0x4000u, 0x4000u};
    v4 acc = {100.0f, 100.0f, 100.0f, 100.0f};
    asm volatile("bfdot %0.4s, %1.8h, %2.8h" : "+w"(acc) : "w"(*(u4*)&da), "w"(*(u4*)&db));
    ZASSERT(acc[0] == 100.0f + 1.0f * 2.0f + 2.0f * 2.0f);
    ZASSERT(acc[1] == 100.0f + 3.0f * 2.0f + 4.0f * 2.0f);
    ZASSERT(acc[2] == 100.0f + 5.0f * 2.0f + 6.0f * 2.0f);
    ZASSERT(acc[3] == 100.0f + 7.0f * 2.0f + 8.0f * 2.0f);

    /* bfdot (by element): Vm.2h[index] picks a bf16 pair of b. */
    v4 acc2 = {0.0f, 0.0f, 0.0f, 0.0f};
    asm volatile("bfdot %0.4s, %1.8h, %2.2h[1]" : "+w"(acc2) : "w"(*(u4*)&da), "w"(*(u4*)&db));
    /* b pair 1 = {2.0, 2.0}; same sums as above but no accumulator. */
    ZASSERT(acc2[0] == 1.0f * 2.0f + 2.0f * 2.0f);
    ZASSERT(acc2[1] == 3.0f * 2.0f + 4.0f * 2.0f);
    ZASSERT(acc2[2] == 5.0f * 2.0f + 6.0f * 2.0f);
    ZASSERT(acc2[3] == 7.0f * 2.0f + 8.0f * 2.0f);

    /* Round trip through bfdot with a zero accumulator must reproduce the
       integer dot products exactly (bf16-exact inputs). */
    v4 zero = {0.0f, 0.0f, 0.0f, 0.0f};
    asm volatile("bfdot %0.4s, %1.8h, %2.8h" : "+w"(zero) : "w"(*(u4*)&da), "w"(*(u4*)&da));
    ZASSERT(zero[0] == 1.0f * 1.0f + 2.0f * 2.0f);
    ZASSERT(zero[1] == 3.0f * 3.0f + 4.0f * 4.0f);
    ZASSERT(zero[2] == 5.0f * 5.0f + 6.0f * 6.0f);
    ZASSERT(zero[3] == 7.0f * 7.0f + 8.0f * 8.0f);
    ZASSERT(zero[3] == 113.0f);
    return 0;
}
