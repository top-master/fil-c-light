#include <stdfil.h>
#include <immintrin.h>

__attribute__((noinline)) __m128i getmask(void)
{
    return _mm_set_epi64x(-1, 0);
}

__attribute__((target("avx"))) int main()
{
    double* buf = zgc_aligned_alloc(16, 16);
    buf[0] = 1.;
    buf[1] = 2.;
    __m128 result = _mm_maskload_pd(buf + 1, getmask());
    _mm_storeu_pd(buf, result);
    zprintf("buf = %lf, %lf\n", buf[0], buf[1]);
    ZASSERT(buf[0] == 2.);
    ZASSERT(buf[1] == 0.);
    return 0;
}

