#include <stdfil.h>
#include <xmmintrin.h>

int main(void)
{
    __m128 a = _mm_setr_ps(1.0f, 2.0f, 3.0f, 4.0f);
    __m128 b = _mm_setr_ps(5.0f, 6.0f, 7.0f, 8.0f);

    asm volatile("blendps $5, %1, %0" : "+x"(a) : "x"(b));

    float r[4];
    _mm_storeu_ps(r, a);
    ZASSERT(r[0] == 5.0f);
    ZASSERT(r[1] == 2.0f);
    ZASSERT(r[2] == 7.0f);
    ZASSERT(r[3] == 4.0f);

    return 0;
}
