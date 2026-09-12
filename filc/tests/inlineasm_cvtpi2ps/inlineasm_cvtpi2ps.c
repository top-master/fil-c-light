#include <stdfil.h>
#include <mmintrin.h>
#include <xmmintrin.h>

int main(void)
{
    __m64 a = _mm_set_pi32(2, 1);
    __m128 b = _mm_set_ps(8.0f, 7.0f, 6.0f, 5.0f);

    asm volatile("cvtpi2ps %1, %0" : "+x"(b) : "y"(a));

    float r[4];
    _mm_storeu_ps(r, b);
    ZASSERT(r[0] == 1.0f);
    ZASSERT(r[1] == 2.0f);
    ZASSERT(r[2] == 7.0f);
    ZASSERT(r[3] == 8.0f);

    return 0;
}
