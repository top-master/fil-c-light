#include <stdfil.h>
#include <emmintrin.h>
#include <string.h>
#include <stdint.h>

int main(void)
{
    __m128 a = _mm_setr_ps(1.0f, 2.0f, 3.0f, 4.0f);
    __m128 b = _mm_setr_ps(2.0f, 2.0f, 3.0f, 4.0f);

    asm volatile("cmpps $0, %1, %0" : "+x"(a) : "x"(b));

    float rf[4];
    uint32_t bits[4];
    _mm_storeu_ps(rf, a);
    memcpy(bits, rf, sizeof(bits));

    ZASSERT(bits[0] == 0);
    ZASSERT(bits[1] == ~0U);
    ZASSERT(bits[2] == ~0U);
    ZASSERT(bits[3] == ~0U);

    return 0;
}
