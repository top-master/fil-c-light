#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

__attribute__((target("avx512f"))) int main() {
    // 16 elements of source data we want to write
    alignas(64) int src_data[16] = {10, 20, 30, 40, 50, 60, 70, 80, 
        90, 100, 110, 120, 130, 140, 150, 160};
    
    // Mask to select elements 1, 3, 5, etc. (Binary: 0101010101010101)
    __mmask16 mask = 0x5555; 
    
    // ---------------------------------------------------------
    // 1. COMPRESS STORE (Write masked elements contiguously)
    // ---------------------------------------------------------
    __m512i zmm_src = _mm512_loadu_si512((__m512i*)src_data);
    alignas(64) int compressed_out[16] = {0};
    
    // Compresses the elements from zmm_src where mask=1 and stores them
    _mm512_mask_compressstoreu_epi32(compressed_out, mask, zmm_src);
    asm volatile("" : : "r"(compressed_out) : "memory");
    for (unsigned i = 0; i < 8; ++i)
        ZASSERT(compressed_out[i] == i * 20 + 10);
    for (unsigned i = 8; i < 16; ++i)
        ZASSERT(!compressed_out[i]);

    // ---------------------------------------------------------
    // 2. EXPAND LOAD (Read contiguous elements back sparsely)
    // ---------------------------------------------------------
    alignas(64) int expanded_out[16] = {0};
    
    // Loads contiguous elements from compressed_out and scatters them
    // into zmm_dst according to the mask. Unmasked elements are zeroed.
    asm volatile("" : : "r"(compressed_out) : "memory");
    __m512i zmm_dst = _mm512_maskz_expandloadu_epi32(mask, compressed_out);
    _mm512_storeu_si512((__m512i*)expanded_out, zmm_dst);
    asm volatile("" : : "r"(expanded_out) : "memory");
    for (unsigned i = 0; i < 8; ++i)
        ZASSERT(expanded_out[i * 2] == i * 20 + 10);
    for (unsigned i = 0; i < 8; ++i)
        ZASSERT(!expanded_out[i * 2 + 1]);

    return 0;
}

