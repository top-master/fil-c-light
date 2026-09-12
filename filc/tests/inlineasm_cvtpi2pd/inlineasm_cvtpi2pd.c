#include <stdfil.h>
#include <mmintrin.h>
#include <emmintrin.h>

int main(void)
{
    __m64 a = _mm_set_pi32(2, 1);
    __m128d b;

    asm volatile("cvtpi2pd %1, %0" : "=x"(b) : "y"(a));

    double r[2];
    _mm_storeu_pd(r, b);
    ZASSERT(r[0] == 1.0);
    ZASSERT(r[1] == 2.0);

    return 0;
}
