#include <stdfil.h>
#include <string.h>

typedef long long v4di __attribute__((vector_size(32)));

/* VPERM2I128 (AVX2): permute 128-bit integer lanes from two YMM sources into a
 * YMM destination under control of an imm8. Same structure and imm8 encoding
 * as VPERM2F128 but for integer data.
 *   VPERM2I128 ymm1, ymm2, ymm3/m256, imm8
 * Intel order: dst, src1, src2, imm8. AT&T order: $imm8, src2, src1, dst.
 */
__attribute__((target("avx2"))) int main(void)
{
    v4di src1 = { 1, 2, 3, 4 };
    v4di src2 = { 10, 20, 30, 40 };

    /* imm8 = 0x10: low=src1.low, high=src1.high -> copy src1. */
    v4di dst = { 0 };
    asm volatile("vperm2i128 $0x10, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 1);
    ZASSERT(dst[1] == 2);
    ZASSERT(dst[2] == 3);
    ZASSERT(dst[3] == 4);

    /* imm8 = 0x32: low=src2.low, high=src2.high -> copy src2. */
    asm volatile("vperm2i128 $0x32, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 10);
    ZASSERT(dst[1] == 20);
    ZASSERT(dst[2] == 30);
    ZASSERT(dst[3] == 40);

    /* imm8 = 0x12: low=src2.low, high=src1.high. */
    asm volatile("vperm2i128 $0x12, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 10);
    ZASSERT(dst[1] == 20);
    ZASSERT(dst[2] == 3);
    ZASSERT(dst[3] == 4);

    /* imm8 = 0x30: low=src1.low, high=src2.high. */
    asm volatile("vperm2i128 $0x30, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 1);
    ZASSERT(dst[1] == 2);
    ZASSERT(dst[2] == 30);
    ZASSERT(dst[3] == 40);

    return 0;
}
