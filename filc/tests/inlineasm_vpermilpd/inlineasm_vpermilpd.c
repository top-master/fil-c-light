#include <stdfil.h>
#include <string.h>

typedef double v2df __attribute__((vector_size(16)));
typedef long long v2di __attribute__((vector_size(16)));

/* VPERMILPD (AVX): permute in-lane pairs of double-precision values.
 * Two register-only AVX forms:
 *   VPERMILPD xmm1, xmm2, xmm3/m128   (variable: control in xmm3)
 *   VPERMILPD xmm1, xmm2/m128, imm8   (immediate: control in imm8)
 * Intel order: dst, data, control/imm8. AT&T order: control/imm8, data, dst.
 * For 128-bit (xmm, 2 doubles): imm8 bit0 selects dst[0], bit1 selects dst[1]
 * (0 -> src[0], 1 -> src[1]). The variable form uses bit1 of each 64-bit
 * control element analogously. */
__attribute__((target("avx"))) int main(void)
{
    v2df data = { 1.0, 2.0 };
    v2df dst = { 0, 0 };

    /* Immediate form: imm8=0x00 -> {src[0], src[0]} = {1.0, 1.0}. */
    asm volatile("vpermilpd $0x0, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1.0);
    ZASSERT(dst[1] == 1.0);

    /* imm8=0x1 -> dst[0]=src[1]=2.0, dst[1]=src[0]=1.0. */
    asm volatile("vpermilpd $0x1, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 2.0);
    ZASSERT(dst[1] == 1.0);

    /* imm8=0x2 -> dst[0]=src[0]=1.0, dst[1]=src[1]=2.0 (identity). */
    asm volatile("vpermilpd $0x2, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 1.0);
    ZASSERT(dst[1] == 2.0);

    /* imm8=0x3 -> {src[1], src[1]} = {2.0, 2.0}. */
    asm volatile("vpermilpd $0x3, %1, %0" : "=x"(dst) : "x"(data));
    ZASSERT(dst[0] == 2.0);
    ZASSERT(dst[1] == 2.0);

    /* Variable form: bit1 of each 64-bit control element selects the source.
     * ctrl=0 -> select src[0] for both -> {1.0, 1.0}. */
    v2di ctrl = { 0, 0 };
    asm volatile("vpermilpd %2, %1, %0" : "=x"(dst) : "x"(data), "x"(ctrl));
    ZASSERT(dst[0] == 1.0);
    ZASSERT(dst[1] == 1.0);

    /* ctrl={2,2}: bit1 set -> select src[1] for both -> {2.0, 2.0}. */
    ctrl = (v2di){ 2, 2 };
    asm volatile("vpermilpd %2, %1, %0" : "=x"(dst) : "x"(data), "x"(ctrl));
    ZASSERT(dst[0] == 2.0);
    ZASSERT(dst[1] == 2.0);

    /* ctrl[0]=2 (select src[1]), ctrl[1]=0 (select src[0]) -> {2.0, 1.0}. */
    ctrl = (v2di){ 2, 0 };
    asm volatile("vpermilpd %2, %1, %0" : "=x"(dst) : "x"(data), "x"(ctrl));
    ZASSERT(dst[0] == 2.0);
    ZASSERT(dst[1] == 1.0);

    return 0;
}
