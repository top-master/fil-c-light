#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // Test _mm256_maskload_epi64 (256-bit version for 64-bit integers)
    long long* buf = zgc_aligned_alloc(32, 32);
    buf[0] = 100;
    buf[1] = 200;
    buf[2] = 300;
    buf[3] = 400;
    
    // Mask: load elements 0 and 2, zero out elements 1 and 3
    // Use 64-bit mask values - the high bit of each 64-bit element controls loading
    __m256i mask = _mm256_set_epi64x(0, 0x8000000000000000LL, 0, 0x8000000000000000LL);
    __m256i result = _mm256_maskload_epi64(buf, mask);
    
    // Store result back to buf
    _mm256_storeu_si256((__m256i*)buf, result);
    
    zprintf("buf = %lld, %lld, %lld, %lld\n", buf[0], buf[1], buf[2], buf[3]);
    
    ZASSERT(buf[0] == 100);
    ZASSERT(buf[1] == 0);
    ZASSERT(buf[2] == 300);
    ZASSERT(buf[3] == 0);
    
    zprintf("64-bit maskload test passed!\n");
    return 0;
}
