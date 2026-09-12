#include <stdfil.h>
#include <immintrin.h>

/* VFIXUPIMMPD (AVX-512F): fix up special packed double-precision FP values
   using a 32-bit two-level lookup table. Intel operand order is
   dst, src1, src2, imm8; AT&T order is $imm8, src2, src1, dst. The lookup
   table has one 4-bit response nibble per token type (8 types). Response
   1100b sets the element to 90.0, so a table of 0xCCCCCCCC (all nibbles
   1100b) forces every element to 90.0 regardless of input. imm8=0 requests
   no MXCSR exception reporting. */
__attribute__((target("avx512f")))
int main(void)
{
    __m512d src = _mm512_set1_pd(42.0);
    __m512i tbl = _mm512_set1_epi64(0xCCCCCCCCULL);
    __m512d dst = _mm512_set1_pd(0.0);

    asm volatile("vfixupimmpd $0, %2, %1, %0" : "=x"(dst) : "x"(src), "x"(tbl));

    double r[8];
    _mm512_storeu_pd(r, dst);
    for (int i = 0; i < 8; ++i)
        ZASSERT(r[i] == 90.0);

    return 0;
}
