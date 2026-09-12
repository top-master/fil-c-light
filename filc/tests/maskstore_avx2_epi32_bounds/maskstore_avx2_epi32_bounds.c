#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // This test should fail because we try to store above the buffer bounds
    int* buf = zgc_aligned_alloc(32, 32);
    
    __m256i values = _mm256_set1_epi32(42);
    __m256i mask = _mm256_set1_epi32(0x80000000); // All bits set - store all elements
    
    // Try to store 8 elements starting 8 elements after the buffer - should fail
    _mm256_maskstore_epi32(buf + 8, mask, values);
    
    zprintf("Should have failed!\n");
    return 0;
}
