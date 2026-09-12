#include <stdfil.h>
#include <string.h>

typedef long long v4di __attribute__((vector_size(32)));

/* VPERMQ (AVX2): permute quadword values across a full YMM destination under
 * control of an imm8. AVX2 provides only the immediate register form:
 *   VPERMQ ymm1, ymm2/m256, imm8
 * Intel order: dst, data, imm8. AT&T order: $imm8, data, dst.
 * For 256-bit (ymm, 4 quadwords): imm8 has four 2-bit fields
 * (dst[0]=imm8[1:0], dst[1]=imm8[3:2], dst[2]=imm8[5:4], dst[3]=imm8[7:6]);
 * each selects one of the 4 source elements. */
__attribute__((target("avx2"))) int main(void)
{
    v4di data = { 1, 2, 3, 4 };
    v4di dst = { 0, 0, 0, 0 };

    /* imm8=0x00: all select src[0] -> {1,1,1,1}. */
    asm volatile("vpermq $0x0, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1);
    ZASSERT(dst[1] == 1);
    ZASSERT(dst[2] == 1);
    ZASSERT(dst[3] == 1);

    /* imm8=0xE4: identity (fields 0,1,2,3) -> {1,2,3,4}. */
    asm volatile("vpermq $0xe4, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1);
    ZASSERT(dst[1] == 2);
    ZASSERT(dst[2] == 3);
    ZASSERT(dst[3] == 4);

    /* imm8=0x1b: reverse (fields 3,2,1,0) -> {4,3,2,1}. */
    asm volatile("vpermq $0x1b, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 4);
    ZASSERT(dst[1] == 3);
    ZASSERT(dst[2] == 2);
    ZASSERT(dst[3] == 1);

    /* imm8=0xff: all select src[3] -> {4,4,4,4}. */
    asm volatile("vpermq $0xff, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 4);
    ZASSERT(dst[1] == 4);
    ZASSERT(dst[2] == 4);
    ZASSERT(dst[3] == 4);

    return 0;
}
