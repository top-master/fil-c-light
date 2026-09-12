#include <stdfil.h>
#include <wmmintrin.h>

int main(void)
{
    __m128i a = _mm_setr_epi8(
        0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
        0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f);
    __m128i expected = _mm_aeskeygenassist_si128(a, 1);
    __m128i result;

    asm volatile("aeskeygenassist $1, %1, %0" : "=x"(result) : "x"(a));

    int mask = _mm_movemask_epi8(_mm_cmpeq_epi8(result, expected));
    ZASSERT(mask == 0xffff);

    return 0;
}
