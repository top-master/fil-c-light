#include <stdfil.h>
#include <nmmintrin.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    /* PCMPISTRI: packed compare implicit-length strings, return index in ECX.
       The explicit operands (xmm1, xmm2, imm8) are all inputs; string lengths
       are implicit (null-terminated). The result index goes to ECX and flags
       are written ("cc"). */
    v16qi a = { 'h','e','l','l','o', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi b = { 'x','l', 0,0,0, 0,0,0, 0,0,0,0, 0,0,0,0 };

    /* "equal any" over unsigned bytes (imm8=0x00). */
    int res;
    asm volatile("pcmpistri $0x00, %2, %1"
                 : "=c"(res)
                 : "x"(a), "x"(b)
                 : "cc");
    ZASSERT(res == _mm_cmpistri((__m128i)a, (__m128i)b, 0x00));

    /* Different inputs with a different control byte. */
    v16qi c = { 'a','b','c','d','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    v16qi d = { 'a','x','c','y','e', 0,0,0, 0,0,0,0, 0,0,0,0 };
    int res2;
    asm volatile("pcmpistri $0x18, %2, %1"
                 : "=c"(res2)
                 : "x"(c), "x"(d)
                 : "cc");
    ZASSERT(res2 == _mm_cmpistri((__m128i)c, (__m128i)d, 0x18));
    return 0;
}
