#include <stdfil.h>
#include <immintrin.h>

/* VFIXUPIMMSD (AVX-512F): fix up the special scalar double-precision FP value
   in the low quadword using a 32-bit two-level lookup table (taken from the
   low 32 bits of src2). Intel operand order is dst, src1, src2, imm8; AT&T
   order is $imm8, src2, src1, dst. Response 1100b sets the element to 90.0,
   so a table of 0xCCCCCCCC forces the low element to 90.0. Bits 127:64 of
   the destination are copied from src1. imm8=0 requests no MXCSR reporting. */
__attribute__((target("avx512f")))
int main(void)
{
    __m128d src = _mm_set_pd(99.0, 42.0);
    __m128i tbl = _mm_set1_epi64x(0xCCCCCCCCULL);
    __m128d dst = _mm_setzero_pd();

    asm volatile("vfixupimmsd $0, %2, %1, %0" : "=x"(dst) : "x"(src), "x"(tbl));

    double r[2];
    _mm_storeu_pd(r, dst);
    ZASSERT(r[0] == 90.0);
    ZASSERT(r[1] == 99.0);

    return 0;
}
