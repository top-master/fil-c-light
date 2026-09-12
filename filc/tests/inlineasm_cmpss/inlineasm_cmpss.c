#include <stdfil.h>
#include <emmintrin.h>
#include <string.h>
#include <stdint.h>

int main(void)
{
    __m128 a = _mm_setr_ps(1.0f, 2.0f, 3.0f, 4.0f);
    __m128 b = _mm_setr_ps(1.0f, 5.0f, 6.0f, 7.0f);

    asm volatile("cmpss $0, %1, %0" : "+x"(a) : "x"(b));

    float rf[4];
    uint32_t bits[4];
    _mm_storeu_ps(rf, a);
    memcpy(bits, rf, sizeof(bits));

    ZASSERT(bits[0] == ~0U);
    ZASSERT(bits[1] == 0x40000000);
    ZASSERT(bits[2] == 0x40400000);
    ZASSERT(bits[3] == 0x40800000);

    return 0;
}
