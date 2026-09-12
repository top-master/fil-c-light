#include <stdfil.h>
#include <emmintrin.h>

int main(void)
{
    __m128d a = _mm_setr_pd(1.0, 2.0);
    __m128d b = _mm_setr_pd(3.0, 4.0);
    __m128d mask = _mm_setr_pd(-1.0, 0.0);

    register __m128d mask_reg asm("xmm0") = mask;
    asm volatile("blendvpd %1, %0" : "+x"(a) : "x"(b), "x"(mask_reg));

    double r[2];
    _mm_storeu_pd(r, a);
    ZASSERT(r[0] == 3.0);
    ZASSERT(r[1] == 2.0);

    return 0;
}
