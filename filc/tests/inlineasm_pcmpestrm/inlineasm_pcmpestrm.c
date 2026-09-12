#include <stdfil.h>
#include <nmmintrin.h>
#include <string.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    /* PCMPESTRM: packed compare explicit-length strings, return mask in XMM0.
       The explicit operands (xmm1, xmm2, imm8) are all inputs; EAX and EDX are
       implicit length inputs (reads are harmless). The result mask goes to XMM0
       (forced via a register asm variable) and flags are written ("cc"). */
    v16qi a = { 'h','e','l','l','o', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi b = { 'x','l', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0 };
    int la = 5, lb = 2;

    register __m128i out asm("xmm0");
    asm volatile("pcmpestrm $0x00, %2, %1"
                 : "=x"(out)
                 : "x"(a), "x"(b), "a"(la), "d"(lb)
                 : "cc");
    __m128i ref = _mm_cmpestrm((__m128i)a, la, (__m128i)b, lb, 0x00);
    __m128i outt = out;
    v16qi outv, refv;
    memcpy(&outv, &outt, sizeof(outv));
    memcpy(&refv, &ref, sizeof(refv));
    ZASSERT(memcmp(&outv, &refv, sizeof(outv)) == 0);

    /* Different inputs and a byte-mask output mode (imm8 bit6=1 -> 0x40). */
    v16qi c = { 'a','b','c','d','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi d = { 'a','x','c','y','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    register __m128i out2 asm("xmm0");
    asm volatile("pcmpestrm $0x40, %2, %1"
                 : "=x"(out2)
                 : "x"(c), "x"(d), "a"(la), "d"(lb)
                 : "cc");
    __m128i ref2 = _mm_cmpestrm((__m128i)c, la, (__m128i)d, lb, 0x40);
    __m128i outt2 = out2;
    v16qi outv2, refv2;
    memcpy(&outv2, &outt2, sizeof(outv2));
    memcpy(&refv2, &ref2, sizeof(refv2));
    ZASSERT(memcmp(&outv2, &refv2, sizeof(outv2)) == 0);
    return 0;
}
