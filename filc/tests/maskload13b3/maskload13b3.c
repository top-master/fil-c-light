#include <stdfil.h>
#include <immintrin.h>

static __attribute__((target("avx"), noinline)) __m256i makemask(void)
{
    return _mm256_set_epi32(0, 0x80000000, 0, 0x80000000, 0, 0x80000000, 0, 0x80000000);
}

__attribute__((target("avx"))) int main()
{
    float* buf = zgc_aligned_alloc(16, 32);
    buf[0] = 1.;
    buf[1] = 2.;
    buf[2] = 3.;
    buf[3] = 4.;
    buf[4] = 5.;
    buf[5] = 6.;
    buf[6] = 7.;
    buf[7] = 8.;
    __m256 result = _mm256_maskload_ps(buf + 2, makemask());
    _mm256_storeu_ps(buf, result);
    zprintf("buf = %f, %f, %f, %f, %f, %f, %f, %f\n", buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
    ZASSERT(buf[0] == 2.);
    ZASSERT(buf[1] == 0.);
    ZASSERT(buf[2] == 4.);
    ZASSERT(buf[3] == 0.);
    ZASSERT(buf[4] == 6.);
    ZASSERT(buf[5] == 0.);
    ZASSERT(buf[6] == 8.);
    ZASSERT(buf[7] == 0.);
    return 0;
}

