#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // Test with all mask bits set - should load all elements
    int* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 10;
    buf[1] = 20;
    buf[2] = 30;
    buf[3] = 40;
    buf[4] = 50;
    buf[5] = 60;
    buf[6] = 70;
    buf[7] = 80;
    
    // All mask bits set - load all elements
    __m256i mask = _mm256_set1_epi32(0x80000000);
    __m256i result = _mm256_maskload_epi32(buf, mask);
    
    // Store result back to a different buffer for verification
    int* out = zgc_aligned_alloc(32, 32);
    _mm256_storeu_si256((__m256i*)out, result);
    
    zprintf("out = %d, %d, %d, %d, %d, %d, %d, %d\n", out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7]);
    
    // All elements should match
    ZASSERT(out[0] == 10);
    ZASSERT(out[1] == 20);
    ZASSERT(out[2] == 30);
    ZASSERT(out[3] == 40);
    ZASSERT(out[4] == 50);
    ZASSERT(out[5] == 60);
    ZASSERT(out[6] == 70);
    ZASSERT(out[7] == 80);
    
    zprintf("All mask test passed!\n");
    return 0;
}
