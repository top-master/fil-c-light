#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // This test should succeed even though we would access beyond the buffer,
    // because the mask prevents actually accessing those locations.
    // We start at buf+4 and would read 8 elements (going 4 beyond the buffer),
    // but only the first 4 mask bits are set.
    int* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 1;
    buf[1] = 2;
    buf[2] = 3;
    buf[3] = 4;
    buf[4] = 5;
    buf[5] = 6;
    buf[6] = 7;
    buf[7] = 8;
    
    // Start at buf+4, but only load the first 4 elements (indices 0-3 relative to buf+4)
    // Mask: [0, 0, 0, 0, 0x80000000, 0x80000000, 0x80000000, 0x80000000]
    // This should load buf[4..7] into result[0..3] and zero out result[4..7]
    __m256i mask = _mm256_set_epi32(0, 0, 0, 0, 0x80000000, 0x80000000, 0x80000000, 0x80000000);
    __m256i result = _mm256_maskload_epi32(buf + 4, mask);
    
    // Store result back to buf for verification
    _mm256_storeu_si256((__m256i*)buf, result);
    
    zprintf("buf = %d, %d, %d, %d, %d, %d, %d, %d\n", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    
    // First 4 elements should have values from original buf[4..7], last 4 should be 0 (masked out)
    ZASSERT(buf[0] == 5);
    ZASSERT(buf[1] == 6);
    ZASSERT(buf[2] == 7);
    ZASSERT(buf[3] == 8);
    ZASSERT(buf[4] == 0);
    ZASSERT(buf[5] == 0);
    ZASSERT(buf[6] == 0);
    ZASSERT(buf[7] == 0);
    
    zprintf("Masked above bounds test passed!\n");
    return 0;
}
