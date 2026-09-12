#include <stdfil.h>
#include <emmintrin.h>

__attribute__((target("sse4.1"))) int main(void)
{
    __m128d a = _mm_setr_pd(2.0, 3.0);
    __m128d b = _mm_setr_pd(4.0, 5.0);

    asm volatile("dppd $0x31, %1, %0" : "+x"(a) : "x"(b));

    double r[2];
    _mm_storeu_pd(r, a);
    ZASSERT(r[0] == 23.0);
    ZASSERT(r[1] == 0.0);

    return 0;
}
