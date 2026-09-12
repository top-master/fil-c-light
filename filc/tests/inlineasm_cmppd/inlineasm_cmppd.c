#include <stdfil.h>
#include <emmintrin.h>
#include <string.h>
#include <stdint.h>

int main(void)
{
    __m128d a = _mm_setr_pd(1.0, 2.0);
    __m128d b = _mm_setr_pd(2.0, 2.0);

    asm volatile("cmppd $0, %1, %0" : "+x"(a) : "x"(b));

    double r[2];
    uint64_t bits[2];
    _mm_storeu_pd(r, a);
    memcpy(bits, r, sizeof(bits));

    ZASSERT(bits[0] == 0);
    ZASSERT(bits[1] == ~0ULL);

    return 0;
}
