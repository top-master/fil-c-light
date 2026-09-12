#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx2"))) int main()
{
    // Test _mm_maskload_epi32 (128-bit version for 32-bit integers)
    int* buf = zgc_aligned_alloc(16, 16);
    buf[0] = 10;
    buf[1] = 20;
    buf[2] = 30;
    buf[3] = 40;
    
    // Mask: load elements 0 and 2, zero out elements 1 and 3
    __m128i mask = _mm_set_epi32(0, 0x80000000, 0, 0x80000000);
    __m128i result = _mm_maskload_epi32(buf, mask);
    
    // Store result back to buf
    _mm_storeu_si128((__m128i*)buf, result);
    
    zprintf("buf = %d, %d, %d, %d\n", buf[0], buf[1], buf[2], buf[3]);
    
    ZASSERT(buf[0] == 10);
    ZASSERT(buf[1] == 0);
    ZASSERT(buf[2] == 30);
    ZASSERT(buf[3] == 0);
    
    zprintf("128-bit maskload test passed!\n");
    return 0;
}
