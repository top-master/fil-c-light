#include <stdfil.h>
#include <emmintrin.h>

int main(void)
{
    __m128d a = _mm_setr_pd(1.0, 2.0);
    __m128d b = _mm_setr_pd(3.0, 4.0);

    asm volatile("blendpd $2, %1, %0" : "+x"(a) : "x"(b));

    double r[2];
    _mm_storeu_pd(r, a);
    ZASSERT(r[0] == 1.0);
    ZASSERT(r[1] == 4.0);

    return 0;
}
