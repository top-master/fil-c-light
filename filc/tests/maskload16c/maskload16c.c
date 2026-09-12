#include <stdfil.h>
#include <immintrin.h>

__attribute__((noinline, target("avx"))) __m256i getmask(void)
{
    return _mm256_set_epi64x(-1, 0, -1, 0);
}

__attribute__((target("avx"))) int main()
{
    double* buf = zgc_aligned_alloc(16, 32);
    buf[0] = 1.;
    buf[1] = 2.;
    buf[2] = 3.;
    buf[3] = 4.;
    __m256 result = _mm256_maskload_pd(buf + 1, getmask());
    _mm256_storeu_pd(buf, result);
    zprintf("buf = %lf, %lf, %lf, %lf\n", buf[0], buf[1], buf[2], buf[3]);
    ZASSERT(buf[0] == 2.);
    ZASSERT(buf[1] == 0.);
    ZASSERT(buf[2] == 4.);
    ZASSERT(buf[3] == 0.);
    return 0;
}

