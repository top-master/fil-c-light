#include <stdfil.h>
#include <string.h>

typedef int v4si __attribute__((vector_size(16)));
typedef int v8si __attribute__((vector_size(32)));

__attribute__((target("avx2"))) int main(void)
{
    /* VINSERTI128 (AVX2): insert a 128-bit packed integer lane from an XMM
       source into a 256-bit YMM destination, copying the remaining lane from a
       second YMM source. Intel order: dst, src1, src2, imm8.
       AT&T order: $imm8, src2, src1, dst. imm8[0] selects the lane (0=low,
       1=high) of dst that receives src2; the other lane comes from src1. */
    v8si src1 = { 1, 2, 3, 4, 5, 6, 7, 8 };
    v4si src2 = { 10, 20, 30, 40 };

    /* Insert src2 into the low 128-bit lane (imm8 = 0); high lane from src1. */
    v8si dst_lo = { 0 };
    asm volatile("vinserti128 $0, %2, %1, %0" : "=x"(dst_lo) : "x"(src1), "x"(src2));
    ZASSERT(dst_lo[0] == 10);
    ZASSERT(dst_lo[1] == 20);
    ZASSERT(dst_lo[2] == 30);
    ZASSERT(dst_lo[3] == 40);
    ZASSERT(dst_lo[4] == 5);
    ZASSERT(dst_lo[5] == 6);
    ZASSERT(dst_lo[6] == 7);
    ZASSERT(dst_lo[7] == 8);

    /* Insert src2 into the high 128-bit lane (imm8 = 1); low lane from src1. */
    v8si dst_hi = { 0 };
    asm volatile("vinserti128 $1, %2, %1, %0" : "=x"(dst_hi) : "x"(src1), "x"(src2));
    ZASSERT(dst_hi[0] == 1);
    ZASSERT(dst_hi[1] == 2);
    ZASSERT(dst_hi[2] == 3);
    ZASSERT(dst_hi[3] == 4);
    ZASSERT(dst_hi[4] == 10);
    ZASSERT(dst_hi[5] == 20);
    ZASSERT(dst_hi[6] == 30);
    ZASSERT(dst_hi[7] == 40);

    return 0;
}
