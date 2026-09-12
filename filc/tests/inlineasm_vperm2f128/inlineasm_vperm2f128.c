#include <stdfil.h>
#include <string.h>

typedef float v8sf __attribute__((vector_size(32)));

/* VPERM2F128 (AVX): permute 128-bit floating-point lanes from two YMM sources
 * into a YMM destination under control of an imm8.
 *   VPERM2F128 ymm1, ymm2, ymm3/m256, imm8
 * Intel order: dst, src1, src2, imm8. AT&T order: $imm8, src2, src1, dst.
 * imm8 bits[1:0] select the low 128-bit lane of dst; bits[5:4] select the high
 * lane. Each 2-bit field: 0=src1.low, 1=src1.high, 2=src2.low, 3=src2.high. */
__attribute__((target("avx"))) int main(void)
{
    v8sf src1 = { 1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f };
    v8sf src2 = { 10.0f, 20.0f, 30.0f, 40.0f, 50.0f, 60.0f, 70.0f, 80.0f };

    /* imm8 = 0x10: low=src1.low, high=src1.high -> copy src1. */
    v8sf dst = { 0 };
    asm volatile("vperm2f128 $0x10, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 2.0f);
    ZASSERT(dst[2] == 3.0f);
    ZASSERT(dst[3] == 4.0f);
    ZASSERT(dst[4] == 5.0f);
    ZASSERT(dst[5] == 6.0f);
    ZASSERT(dst[6] == 7.0f);
    ZASSERT(dst[7] == 8.0f);

    /* imm8 = 0x32: low=src2.low, high=src2.high -> copy src2. */
    asm volatile("vperm2f128 $0x32, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 10.0f);
    ZASSERT(dst[1] == 20.0f);
    ZASSERT(dst[2] == 30.0f);
    ZASSERT(dst[3] == 40.0f);
    ZASSERT(dst[4] == 50.0f);
    ZASSERT(dst[5] == 60.0f);
    ZASSERT(dst[6] == 70.0f);
    ZASSERT(dst[7] == 80.0f);

    /* imm8 = 0x12: low=src2.low, high=src1.high. */
    asm volatile("vperm2f128 $0x12, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 10.0f);
    ZASSERT(dst[1] == 20.0f);
    ZASSERT(dst[2] == 30.0f);
    ZASSERT(dst[3] == 40.0f);
    ZASSERT(dst[4] == 5.0f);
    ZASSERT(dst[5] == 6.0f);
    ZASSERT(dst[6] == 7.0f);
    ZASSERT(dst[7] == 8.0f);

    /* imm8 = 0x30: low=src1.low, high=src2.high. */
    asm volatile("vperm2f128 $0x30, %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));
    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 2.0f);
    ZASSERT(dst[2] == 3.0f);
    ZASSERT(dst[3] == 4.0f);
    ZASSERT(dst[4] == 50.0f);
    ZASSERT(dst[5] == 60.0f);
    ZASSERT(dst[6] == 70.0f);
    ZASSERT(dst[7] == 80.0f);

    return 0;
}
