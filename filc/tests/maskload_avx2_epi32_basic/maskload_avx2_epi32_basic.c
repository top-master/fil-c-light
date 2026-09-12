#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // Test basic functionality of _mm256_maskload_epi32
    int* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 1;
    buf[1] = 2;
    buf[2] = 3;
    buf[3] = 4;
    buf[4] = 5;
    buf[5] = 6;
    buf[6] = 7;
    buf[7] = 8;
    
    // Mask with alternating bits: load elements 0, 2, 4, 6; zero out elements 1, 3, 5, 7
    __m256i mask = _mm256_set_epi32(0, 0x80000000, 0, 0x80000000, 0, 0x80000000, 0, 0x80000000);
    __m256i result = _mm256_maskload_epi32(buf, mask);
    
    // Store result back to buf
    _mm256_storeu_si256((__m256i*)buf, result);
    
    zprintf("buf = %d, %d, %d, %d, %d, %d, %d, %d\n", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    
    // Check results - even indices should have original values, odd indices should be 0
    ZASSERT(buf[0] == 1);
    ZASSERT(buf[1] == 0);
    ZASSERT(buf[2] == 3);
    ZASSERT(buf[3] == 0);
    ZASSERT(buf[4] == 5);
    ZASSERT(buf[5] == 0);
    ZASSERT(buf[6] == 7);
    ZASSERT(buf[7] == 0);
    
    zprintf("Basic test passed!\n");
    return 0;
}
