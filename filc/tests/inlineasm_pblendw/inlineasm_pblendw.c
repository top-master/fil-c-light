#include <stdfil.h>
#include <emmintrin.h>

int main(void)
{
    /* PBLENDW selects words from src according to imm8 mask bits. */
    __m128i a = _mm_setr_epi16(0, 1, 2, 3, 4, 5, 6, 7);
    __m128i b = _mm_setr_epi16(100, 101, 102, 103, 104, 105, 106, 107);
    /* imm8 = 0x55 = 0b01010101: bits 0,2,4,6 set -> words 0,2,4,6 from b. */
    asm volatile("pblendw $0x55, %1, %0" : "+x"(a) : "x"(b));

    short r[8];
    _mm_storeu_si128((__m128i*)r, a);
    for (int i = 0; i < 8; ++i) {
        short expected = (i % 2 == 0) ? (short)(100 + i) : (short)i;
        ZASSERT(r[i] == expected);
    }

    return 0;
}
