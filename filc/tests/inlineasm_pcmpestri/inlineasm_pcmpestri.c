#include <stdfil.h>
#include <nmmintrin.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    /* PCMPESTRI: packed compare explicit-length strings, return index in ECX.
       The explicit operands (xmm1, xmm2, imm8) are all inputs; EAX (length of
       xmm1) and EDX (length of xmm2) are implicit inputs (reads are harmless),
       and the result index goes to ECX. Flags are also written ("cc" clobber). */
    v16qi a = { 'h','e','l','l','o', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi b = { 'x','l', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0 };
    int la = 5, lb = 2;

    /* "equal any" over unsigned bytes (imm8=0x00). */
    int res;
    asm volatile("pcmpestri $0x00, %2, %1"
                 : "=c"(res)
                 : "x"(a), "x"(b), "a"(la), "d"(lb)
                 : "cc");
    ZASSERT(res == _mm_cmpestri((__m128i)a, la, (__m128i)b, lb, 0x00));

    /* Different inputs with a different control byte. */
    v16qi c = { 'a','b','c','d','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi d = { 'a','x','c','y','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    int res2;
    asm volatile("pcmpestri $0x18, %2, %1"
                 : "=c"(res2)
                 : "x"(c), "x"(d), "a"(la), "d"(lb)
                 : "cc");
    ZASSERT(res2 == _mm_cmpestri((__m128i)c, la, (__m128i)d, lb, 0x18));
    return 0;
}
