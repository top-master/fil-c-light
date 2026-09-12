#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

__attribute__((target("avx512f"))) int main() {
    // 16 elements of source data we want to write
    alignas(64) int src_data[16] = {10, 20, 30, 40, 50, 60, 70, 80, 
        90, 100, 110, 120, 130, 140, 150, 160};
    
    alignas(64) int expanded_out[16] = {0};
    
    // Loads contiguous elements from compressed_out and scatters them
    // into zmm_dst according to the mask. Unmasked elements are zeroed.
    asm volatile("" : : "r"(src_data) : "memory");
    __mmask16 mask = 0x5555;
    __m512i zmm_dst = _mm512_maskz_expandloadu_epi32(mask, src_data - 1);
    _mm512_storeu_si512((__m512i*)expanded_out, zmm_dst);
    asm volatile("" : : "r"(expanded_out) : "memory");

    return 0;
}
