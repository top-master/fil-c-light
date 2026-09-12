#include <stdfil.h>
#include <immintrin.h>

/* VFIXUPIMMSS (AVX-512F): fix up the special scalar single-precision FP value
   in the low doubleword using a 32-bit two-level lookup table (taken from the
   low 32 bits of src2). Intel operand order is dst, src1, src2, imm8; AT&T
   order is $imm8, src2, src1, dst. Response 1100b sets the element to 90.0,
   so a table of 0xCCCCCCCC forces the low element to 90.0. Bits 127:32 of
   the destination are copied from src1. imm8=0 requests no MXCSR reporting. */
__attribute__((target("avx512f")))
int main(void)
{
    __m128 src = _mm_set_ps(8.0f, 7.0f, 6.0f, 5.0f);
    __m128i tbl = _mm_set1_epi32(0xCCCCCCCC);
    __m128 dst = _mm_setzero_ps();

    asm volatile("vfixupimmss $0, %2, %1, %0" : "=x"(dst) : "x"(src), "x"(tbl));

    float r[4];
    _mm_storeu_ps(r, dst);
    ZASSERT(r[0] == 90.0f);
    ZASSERT(r[1] == 6.0f);
    ZASSERT(r[2] == 7.0f);
    ZASSERT(r[3] == 8.0f);

    return 0;
}
