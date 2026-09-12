#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // This test should succeed even though we start loading from below the buffer,
    // because the mask prevents actually accessing those locations.
    // We allocate 32 bytes (8 ints) but start loading from 4 elements before,
    // with only the last 4 mask bits set.
    int* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 1;
    buf[1] = 2;
    buf[2] = 3;
    buf[3] = 4;
    buf[4] = 5;
    buf[5] = 6;
    buf[6] = 7;
    buf[7] = 8;
    
    // Start 4 elements before buf, but only load the last 4 elements (indices 4-7)
    // Mask: [0, 0, 0, 0, 0x80000000, 0x80000000, 0x80000000, 0x80000000]
    // This should load buf[0..3] into result[4..7] and zero out result[0..3]
    __m256i mask = _mm256_set_epi32(0x80000000, 0x80000000, 0x80000000, 0x80000000, 0, 0, 0, 0);
    __m256i result = _mm256_maskload_epi32(buf - 4, mask);
    
    // Store result back to buf for verification
    _mm256_storeu_si256((__m256i*)buf, result);
    
    zprintf("buf = %d, %d, %d, %d, %d, %d, %d, %d\n", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    
    // First 4 elements should be 0 (masked out), last 4 should have values from original buf[0..3]
    ZASSERT(buf[0] == 0);
    ZASSERT(buf[1] == 0);
    ZASSERT(buf[2] == 0);
    ZASSERT(buf[3] == 0);
    ZASSERT(buf[4] == 1);
    ZASSERT(buf[5] == 2);
    ZASSERT(buf[6] == 3);
    ZASSERT(buf[7] == 4);
    
    zprintf("Masked below bounds test passed!\n");
    return 0;
}
