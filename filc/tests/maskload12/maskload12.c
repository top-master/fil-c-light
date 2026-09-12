#include <stdfil.h>
#include <immintrin.h>

__attribute__((target("avx"))) int main()
{
    float* buf = zgc_aligned_alloc(16, 16);
    buf[0] = 1.;
    buf[1] = 2.;
    buf[2] = 3.;
    buf[3] = 4.;
    __m128 result = _mm_maskload_ps(buf, _mm_set_epi32(0, 0x80000000, 0, 0x80000000));
    _mm_storeu_ps(buf, result);
    zprintf("buf = %f, %f, %f, %f\n", buf[0], buf[1], buf[2], buf[3]);
    ZASSERT(buf[0] == 1.);
    ZASSERT(buf[1] == 0.);
    ZASSERT(buf[2] == 3.);
    ZASSERT(buf[3] == 0.);
    return 0;
}

