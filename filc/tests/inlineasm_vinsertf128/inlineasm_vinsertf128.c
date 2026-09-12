#include <stdfil.h>
#include <string.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef float v8sf __attribute__((vector_size(32)));

__attribute__((target("avx"))) int main(void)
{
    /* VINSERTF128 (AVX): insert a 128-bit packed floating-point lane from an
       XMM source into a 256-bit YMM destination, copying the remaining lane
       from a second YMM source. Intel order: dst, src1, src2, imm8.
       AT&T order: $imm8, src2, src1, dst. imm8[0] selects the lane (0=low,
       1=high) of dst that receives src2; the other lane comes from src1. */
    v8sf src1 = { 1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f };
    v4sf src2 = { 10.0f, 20.0f, 30.0f, 40.0f };

    /* Insert src2 into the low 128-bit lane (imm8 = 0); high lane from src1. */
    v8sf dst_lo = { 0 };
    asm volatile("vinsertf128 $0, %2, %1, %0" : "=x"(dst_lo) : "x"(src1), "x"(src2));
    ZASSERT(dst_lo[0] == 10.0f);
    ZASSERT(dst_lo[1] == 20.0f);
    ZASSERT(dst_lo[2] == 30.0f);
    ZASSERT(dst_lo[3] == 40.0f);
    ZASSERT(dst_lo[4] == 5.0f);
    ZASSERT(dst_lo[5] == 6.0f);
    ZASSERT(dst_lo[6] == 7.0f);
    ZASSERT(dst_lo[7] == 8.0f);

    /* Insert src2 into the high 128-bit lane (imm8 = 1); low lane from src1. */
    v8sf dst_hi = { 0 };
    asm volatile("vinsertf128 $1, %2, %1, %0" : "=x"(dst_hi) : "x"(src1), "x"(src2));
    ZASSERT(dst_hi[0] == 1.0f);
    ZASSERT(dst_hi[1] == 2.0f);
    ZASSERT(dst_hi[2] == 3.0f);
    ZASSERT(dst_hi[3] == 4.0f);
    ZASSERT(dst_hi[4] == 10.0f);
    ZASSERT(dst_hi[5] == 20.0f);
    ZASSERT(dst_hi[6] == 30.0f);
    ZASSERT(dst_hi[7] == 40.0f);

    return 0;
}
