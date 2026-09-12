#include <immintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdfil.h>

__attribute__((target("avx512f"))) void do_store(__mmask16 mask,
                                                 int* src_data,
                                                 int* compressed_out);
__attribute__((target("avx512f"))) void do_load(__mmask16 mask,
                                                int* compressed_out,
                                                int* expanded_out);
__attribute__((target("avx512f"))) int main() {
    // 16 elements of source data we want to write
    alignas(64) int src_data[16] = {10, 20, 30, 40, 50, 60, 70, 80, 
        90, 100, 110, 120, 130, 140, 150, 160};
    
    // Mask to select elements 1, 3, 5, etc. (Binary: 0101010101010101)
    __mmask16 mask = 0x5555; 
    
    alignas(64) int compressed_out[16] = {0};
    do_store(mask, src_data, compressed_out);
    for (unsigned i = 0; i < 8; ++i)
        ZASSERT(compressed_out[i] == i * 20 + 10);
    for (unsigned i = 8; i < 16; ++i)
        ZASSERT(!compressed_out[i]);

    // ---------------------------------------------------------
    // 2. EXPAND LOAD (Read contiguous elements back sparsely)
    // ---------------------------------------------------------
    alignas(64) int expanded_out[16] = {0};
    do_load(mask, compressed_out, expanded_out);
    for (unsigned i = 0; i < 8; ++i)
        ZASSERT(expanded_out[i * 2] == i * 20 + 10);
    for (unsigned i = 0; i < 8; ++i)
        ZASSERT(!expanded_out[i * 2 + 1]);

    return 0;
}
