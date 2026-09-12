#include <stdfil.h>
#include <immintrin.h>

int main(void)
{
    /* VPBLENDVB: dest = (mask high bit set) ? src2 : src1, per byte. */
    __m128i a = _mm_setzero_si128();
    __m128i b = _mm_setr_epi8(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15);
    __m128i c = _mm_setr_epi8(100, 101, 102, 103, 104, 105, 106, 107,
                              108, 109, 110, 111, 112, 113, 114, 115);
    __m128i mask = _mm_setr_epi8((char)0x80, 0, (char)0x80, 0, (char)0x80, 0,
                                 (char)0x80, 0, (char)0x80, 0, (char)0x80, 0,
                                 (char)0x80, 0, (char)0x80, 0);

    asm volatile("vpblendvb %3, %2, %1, %0" : "+x"(a) : "x"(b), "x"(c), "x"(mask));

    char r[16];
    _mm_storeu_si128((__m128i*)r, a);
    for (int i = 0; i < 16; ++i) {
        char expected = (i % 2 == 0) ? (char)(100 + i) : (char)i;
        ZASSERT(r[i] == expected);
    }

    return 0;
}
