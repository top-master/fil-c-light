#include <stdfil.h>
#include <nmmintrin.h>
#include <string.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    /* PCMPISTRM: packed compare implicit-length strings, return mask in XMM0.
       The explicit operands (xmm1, xmm2, imm8) are all inputs; string lengths
       are implicit (null-terminated). The result mask goes to XMM0 (forced via
       a register asm variable) and flags are written ("cc"). */
    v16qi a = { 'h','e','l','l','o', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi b = { 'x','l', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0 };

    register __m128i out asm("xmm0");
    asm volatile("pcmpistrm $0x00, %2, %1"
                 : "=x"(out)
                 : "x"(a), "x"(b)
                 : "cc");
    __m128i ref = _mm_cmpistrm((__m128i)a, (__m128i)b, 0x00);
    __m128i outt = out;
    v16qi outv, refv;
    memcpy(&outv, &outt, sizeof(outv));
    memcpy(&refv, &ref, sizeof(refv));
    ZASSERT(memcmp(&outv, &refv, sizeof(outv)) == 0);

    /* Different inputs and a byte-mask output mode (imm8 bit6=1 -> 0x40). */
    v16qi c = { 'a','b','c','d','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi d = { 'a','x','c','y','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    register __m128i out2 asm("xmm0");
    asm volatile("pcmpistrm $0x40, %2, %1"
                 : "=x"(out2)
                 : "x"(c), "x"(d)
                 : "cc");
    __m128i ref2 = _mm_cmpistrm((__m128i)c, (__m128i)d, 0x40);
    __m128i outt2 = out2;
    v16qi outv2, refv2;
    memcpy(&outv2, &outt2, sizeof(outv2));
    memcpy(&refv2, &ref2, sizeof(refv2));
    ZASSERT(memcmp(&outv2, &refv2, sizeof(outv2)) == 0);
    return 0;
}
