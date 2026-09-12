#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // Test various edge cases for _mm256_maskload_epi32
    
    // Test 1: All zeros mask - should load nothing
    {
        int* buf = zgc_aligned_alloc(32, 32);
        buf[0] = 1; buf[1] = 2; buf[2] = 3; buf[3] = 4;
        buf[4] = 5; buf[5] = 6; buf[6] = 7; buf[7] = 8;
        
        __m256i mask = _mm256_setzero_si256(); // All zeros - load nothing
        __m256i result = _mm256_maskload_epi32(buf, mask);
        
        int* out = zgc_aligned_alloc(32, 32);
        _mm256_storeu_si256((__m256i*)out, result);
        
        for (int i = 0; i < 8; i++) {
            ZASSERT(out[i] == 0);
        }
        zprintf("Test 1 (all zeros mask) passed\n");
    }
    
    // Test 2: All ones mask - should load everything
    {
        int* buf = zgc_aligned_alloc(32, 32);
        buf[0] = 10; buf[1] = 20; buf[2] = 30; buf[3] = 40;
        buf[4] = 50; buf[5] = 60; buf[6] = 70; buf[7] = 80;
        
        __m256i mask = _mm256_set1_epi32(-1); // All ones - load everything
        __m256i result = _mm256_maskload_epi32(buf, mask);
        
        int* out = zgc_aligned_alloc(32, 32);
        _mm256_storeu_si256((__m256i*)out, result);
        
        ZASSERT(out[0] == 10);
        ZASSERT(out[1] == 20);
        ZASSERT(out[2] == 30);
        ZASSERT(out[3] == 40);
        ZASSERT(out[4] == 50);
        ZASSERT(out[5] == 60);
        ZASSERT(out[6] == 70);
        ZASSERT(out[7] == 80);
        zprintf("Test 2 (all ones mask) passed\n");
    }
    
    // Test 3: First half masked, second half unmasked
    {
        int* buf = zgc_aligned_alloc(32, 32);
        buf[0] = 1; buf[1] = 2; buf[2] = 3; buf[3] = 4;
        buf[4] = 5; buf[5] = 6; buf[6] = 7; buf[7] = 8;
        
        // First 4 elements masked (load), last 4 unmasked (zero)
        __m256i mask = _mm256_set_epi32(0, 0, 0, 0, 0x80000000, 0x80000000, 0x80000000, 0x80000000);
        __m256i result = _mm256_maskload_epi32(buf, mask);
        
        int* out = zgc_aligned_alloc(32, 32);
        _mm256_storeu_si256((__m256i*)out, result);
        
        ZASSERT(out[0] == 1);
        ZASSERT(out[1] == 2);
        ZASSERT(out[2] == 3);
        ZASSERT(out[3] == 4);
        ZASSERT(out[4] == 0);
        ZASSERT(out[5] == 0);
        ZASSERT(out[6] == 0);
        ZASSERT(out[7] == 0);
        zprintf("Test 3 (first half masked) passed\n");
    }
    
    // Test 4: Negative values
    {
        int* buf = zgc_aligned_alloc(32, 32);
        buf[0] = -1; buf[1] = -2; buf[2] = -3; buf[3] = -4;
        buf[4] = -5; buf[5] = -6; buf[6] = -7; buf[7] = -8;
        
        __m256i mask = _mm256_set1_epi32(0x80000000);
        __m256i result = _mm256_maskload_epi32(buf, mask);
        
        int* out = zgc_aligned_alloc(32, 32);
        _mm256_storeu_si256((__m256i*)out, result);
        
        ZASSERT(out[0] == -1);
        ZASSERT(out[1] == -2);
        ZASSERT(out[2] == -3);
        ZASSERT(out[3] == -4);
        ZASSERT(out[4] == -5);
        ZASSERT(out[5] == -6);
        ZASSERT(out[6] == -7);
        ZASSERT(out[7] == -8);
        zprintf("Test 4 (negative values) passed\n");
    }
    
    zprintf("All edge case tests passed!\n");
    return 0;
}
