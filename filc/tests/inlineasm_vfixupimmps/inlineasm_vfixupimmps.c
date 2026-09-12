#include <stdfil.h>
#include <immintrin.h>

/* VFIXUPIMMPS (AVX-512F): fix up special packed single-precision FP values
   using a 32-bit two-level lookup table. Intel operand order is
   dst, src1, src2, imm8; AT&T order is $imm8, src2, src1, dst. The lookup
   table has one 4-bit response nibble per token type (8 types). Response
   1100b sets the element to 90.0, so a table of 0xCCCCCCCC (all nibbles
   1100b) forces every element to 90.0 regardless of input. imm8=0 requests
   no MXCSR exception reporting. */
__attribute__((target("avx512f")))
int main(void)
{
    __m512 src = _mm512_set1_ps(7.0f);
    __m512i tbl = _mm512_set1_epi32(0xCCCCCCCC);
    __m512 dst = _mm512_set1_ps(0.0f);

    asm volatile("vfixupimmps $0, %2, %1, %0" : "=x"(dst) : "x"(src), "x"(tbl));

    float r[16];
    _mm512_storeu_ps(r, dst);
    for (int i = 0; i < 16; ++i)
        ZASSERT(r[i] == 90.0f);

    return 0;
}
