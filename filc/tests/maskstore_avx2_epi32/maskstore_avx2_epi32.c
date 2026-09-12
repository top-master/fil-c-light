#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // Test _mm256_maskstore_epi32 (256-bit maskstore for 32-bit integers)
    int* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 0;
    buf[1] = 0;
    buf[2] = 0;
    buf[3] = 0;
    buf[4] = 0;
    buf[5] = 0;
    buf[6] = 0;
    buf[7] = 0;
    
    // Values to store
    __m256i values = _mm256_set_epi32(80, 70, 60, 50, 40, 30, 20, 10);
    
    // Mask: store elements 0, 2, 4, 6; skip elements 1, 3, 5, 7
    __m256i mask = _mm256_set_epi32(0, 0x80000000, 0, 0x80000000, 0, 0x80000000, 0, 0x80000000);
    
    _mm256_maskstore_epi32(buf, mask, values);
    
    zprintf("buf = %d, %d, %d, %d, %d, %d, %d, %d\n", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    
    // Even indices should have values, odd indices should still be 0
    ZASSERT(buf[0] == 10);
    ZASSERT(buf[1] == 0);
    ZASSERT(buf[2] == 30);
    ZASSERT(buf[3] == 0);
    ZASSERT(buf[4] == 50);
    ZASSERT(buf[5] == 0);
    ZASSERT(buf[6] == 70);
    ZASSERT(buf[7] == 0);
    
    zprintf("Maskstore test passed!\n");
    return 0;
}
