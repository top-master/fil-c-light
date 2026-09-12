#include <stdfil.h>
#include <xmmintrin.h>

__attribute__((target("sse4.1"))) int main(void)
{
    __m128 a = _mm_setr_ps(1.0f, 2.0f, 3.0f, 4.0f);
    __m128 b = _mm_setr_ps(5.0f, 6.0f, 7.0f, 8.0f);

    asm volatile("dpps $0xf1, %1, %0" : "+x"(a) : "x"(b));

    float r[4];
    _mm_storeu_ps(r, a);
    ZASSERT(r[0] == 70.0f);
    ZASSERT(r[1] == 0.0f);
    ZASSERT(r[2] == 0.0f);
    ZASSERT(r[3] == 0.0f);

    return 0;
}
