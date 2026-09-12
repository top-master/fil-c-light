#include <stdfil.h>
#include <immintrin.h>

int main(void)
{
    /* VPBLENDD: dest = (imm8 bit set) ? src2 : src1, per dword. */
    __m128i a = _mm_setzero_si128();
    __m128i b = _mm_setr_epi32(0, 1, 2, 3);
    __m128i c = _mm_setr_epi32(100, 101, 102, 103);
    /* imm8 = 0x05: bits 0,2 set -> dwords 0,2 from c, rest from b. */
    asm volatile("vpblendd $0x05, %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    int r[4];
    _mm_storeu_si128((__m128i*)r, a);
    for (int i = 0; i < 4; ++i) {
        int expected = (i == 0 || i == 2) ? (100 + i) : i;
        ZASSERT(r[i] == expected);
    }

    return 0;
}
