#include <stdfil.h>
#include <string.h>

typedef unsigned long long v2di __attribute__((vector_size(16)));

static unsigned long long clmul(unsigned long long x, unsigned long long y)
{
    unsigned long long r = 0;
    for (int i = 0; i < 64; i++) {
        if (y & (1ULL << i))
            r ^= x << i;
    }
    return r;
}

__attribute__((target("avx,pclmul"))) int main(void)
{
    v2di a = { 3, 7 };
    v2di b = { 5, 11 };
    v2di result;

    /* vpclmulqdq $0: CL_MUL(b[63:0], a[63:0]) -> result. */
    asm volatile("vpclmulqdq $0, %2, %1, %0" : "=x"(result) : "x"(a), "x"(b));
    unsigned long long r[2];
    memcpy(r, &result, sizeof(r));
    ZASSERT(r[0] == clmul(3, 5));
    ZASSERT(r[1] == 0);

    /* vpclmulqdq $0x10: CL_MUL(b[127:64], a[63:0]) -> result. */
    asm volatile("vpclmulqdq $0x10, %2, %1, %0" : "=x"(result) : "x"(a), "x"(b));
    memcpy(r, &result, sizeof(r));
    ZASSERT(r[0] == clmul(11, 3));
    ZASSERT(r[1] == 0);

    return 0;
}
