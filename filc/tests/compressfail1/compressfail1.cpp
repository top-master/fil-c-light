#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

__attribute__((target("avx512f"))) int main() {
    // 16 elements of source data we want to write
    alignas(64) int src_data[16] = {10, 20, 30, 40, 50, 60, 70, 80, 
        90, 100, 110, 120, 130, 140, 150, 160};
    
    __mmask16 mask = 0x5555;
    
    // ---------------------------------------------------------
    // 1. COMPRESS STORE (Write masked elements contiguously)
    // ---------------------------------------------------------
    __m512i zmm_src = _mm512_loadu_si512((__m512i*)src_data);
    alignas(64) int compressed_out[16] = {0};
    
    // Compresses the elements from zmm_src where mask=1 and stores them
    _mm512_mask_compressstoreu_epi32(compressed_out - 1, mask, zmm_src);
    asm volatile("" : : "r"(compressed_out) : "memory");

    return 0;
}
