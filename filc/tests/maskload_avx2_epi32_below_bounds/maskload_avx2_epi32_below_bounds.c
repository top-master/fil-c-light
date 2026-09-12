#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // This test should fail because we try to access below the buffer bounds
    int* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 1;
    buf[1] = 2;
    buf[2] = 3;
    buf[3] = 4;
    buf[4] = 5;
    buf[5] = 6;
    buf[6] = 7;
    buf[7] = 8;
    
    // Try to load from 8 elements before the buffer start - should fail
    __m256i mask = _mm256_set1_epi32(0x80000000); // All bits set - load all elements
    __m256i result = _mm256_maskload_epi32(buf - 8, mask);
    
    _mm256_storeu_si256((__m256i*)buf, result);
    
    zprintf("Should have failed!\n");
    return 0;
}
