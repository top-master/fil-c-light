#include <stdfil.h>
#include <string.h>

typedef double v4df __attribute__((vector_size(32)));

/* VPERMPD (AVX2): permute double-precision values across a full YMM
 * destination under control of an imm8. AVX2 provides only the immediate
 * register form:
 *   VPERMPD ymm1, ymm2/m256, imm8
 * Intel order: dst, data, imm8. AT&T order: $imm8, data, dst.
 * For 256-bit (ymm, 4 doubles): imm8 has four 2-bit fields
 * (dst[0]=imm8[1:0], dst[1]=imm8[3:2], dst[2]=imm8[5:4], dst[3]=imm8[7:6]);
 * each selects one of the 4 source elements. */
__attribute__((target("avx2"))) int main(void)
{
    v4df data = { 1.0, 2.0, 3.0, 4.0 };
    v4df dst = { 0, 0, 0, 0 };

    /* imm8=0x00: all select src[0] -> {1,1,1,1}. */
    asm volatile("vpermpd $0x0, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1.0);
    ZASSERT(dst[1] == 1.0);
    ZASSERT(dst[2] == 1.0);
    ZASSERT(dst[3] == 1.0);

    /* imm8=0xE4: identity (fields 0,1,2,3) -> {1,2,3,4}. */
    asm volatile("vpermpd $0xe4, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1.0);
    ZASSERT(dst[1] == 2.0);
    ZASSERT(dst[2] == 3.0);
    ZASSERT(dst[3] == 4.0);

    /* imm8=0x1b: reverse (fields 3,2,1,0) -> {4,3,2,1}. */
    asm volatile("vpermpd $0x1b, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 4.0);
    ZASSERT(dst[1] == 3.0);
    ZASSERT(dst[2] == 2.0);
    ZASSERT(dst[3] == 1.0);

    /* imm8=0xff: all select src[3] -> {4,4,4,4}. */
    asm volatile("vpermpd $0xff, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 4.0);
    ZASSERT(dst[1] == 4.0);
    ZASSERT(dst[2] == 4.0);
    ZASSERT(dst[3] == 4.0);

    return 0;
}
