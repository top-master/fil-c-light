#include <stdfil.h>
#include <string.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

/* VPERMILPS (AVX): permute in-lane single-precision values.
 * Two register-only AVX forms:
 *   VPERMILPS xmm1, xmm2, xmm3/m128   (variable: control in xmm3)
 *   VPERMILPS xmm1, xmm2/m128, imm8   (immediate: control in imm8)
 * Intel order: dst, data, control/imm8. AT&T order: control/imm8, data, dst.
 * For 128-bit (xmm, 4 floats): imm8 has four 2-bit fields (dst[0]=imm8[1:0],
 * dst[1]=imm8[3:2], dst[2]=imm8[5:4], dst[3]=imm8[7:6]); each selects one of
 * the 4 source elements. The variable form uses bits[1:0] of each 32-bit
 * control element. */
__attribute__((target("avx"))) int main(void)
{
    v4sf data = { 1.0f, 2.0f, 3.0f, 4.0f };
    v4sf dst = { 0, 0, 0, 0 };

    /* imm8=0x00: all select src[0] -> {1,1,1,1}. */
    asm volatile("vpermilps $0x0, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 1.0f);
    ZASSERT(dst[2] == 1.0f);
    ZASSERT(dst[3] == 1.0f);

    /* imm8=0xE4: identity (fields 0,1,2,3) -> {1,2,3,4}. */
    asm volatile("vpermilps $0xe4, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 2.0f);
    ZASSERT(dst[2] == 3.0f);
    ZASSERT(dst[3] == 4.0f);

    /* imm8=0x1b: reverse (fields 3,2,1,0) -> {4,3,2,1}. */
    asm volatile("vpermilps $0x1b, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 4.0f);
    ZASSERT(dst[1] == 3.0f);
    ZASSERT(dst[2] == 2.0f);
    ZASSERT(dst[3] == 1.0f);

    /* imm8=0xff: all select src[3] -> {4,4,4,4}. */
    asm volatile("vpermilps $0xff, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 4.0f);
    ZASSERT(dst[1] == 4.0f);
    ZASSERT(dst[2] == 4.0f);
    ZASSERT(dst[3] == 4.0f);

    /* Variable form: bits[1:0] of each 32-bit control element select.
     * ctrl={0,0,0,0} -> {1,1,1,1}. */
    v4si ctrl = { 0, 0, 0, 0 };
    asm volatile("vpermilps %2, %1, %0" : "=x"(dst) : "x"(data), "x"(ctrl));
    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 1.0f);
    ZASSERT(dst[2] == 1.0f);
    ZASSERT(dst[3] == 1.0f);

    /* ctrl={3,2,1,0} -> {src[3],src[2],src[1],src[0]} = {4,3,2,1}. */
    ctrl = (v4si){ 3, 2, 1, 0 };
    asm volatile("vpermilps %2, %1, %0" : "=x"(dst) : "x"(data), "x"(ctrl));
    ZASSERT(dst[0] == 4.0f);
    ZASSERT(dst[1] == 3.0f);
    ZASSERT(dst[2] == 2.0f);
    ZASSERT(dst[3] == 1.0f);

    /* ctrl={0,1,2,3} -> identity {1,2,3,4}. */
    ctrl = (v4si){ 0, 1, 2, 3 };
    asm volatile("vpermilps %2, %1, %0" : "=x"(dst) : "x"(data), "x"(ctrl));
    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 2.0f);
    ZASSERT(dst[2] == 3.0f);
    ZASSERT(dst[3] == 4.0f);

    return 0;
}
