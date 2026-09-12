#include <stdfil.h>
#include <string.h>

typedef unsigned long long v2di __attribute__((vector_size(16)));

/* Carry-less multiplication over GF(2): polynomial multiplication with
 * XOR instead of addition.  CL_MUL(3, 5):
 *   3 = x + 1, 5 = x^2 + 1  ->  (x+1)(x^2+1) = x^3 + x^2 + x + 1 = 0xf
 * which fits in 64 bits, so the high 64 bits of the 128-bit result are 0.
 */
static unsigned long long clmul(unsigned long long x, unsigned long long y)
{
    unsigned long long r = 0;
    for (int i = 0; i < 64; i++) {
        if (y & (1ULL << i))
            r ^= x << i;
    }
    return r;
}

int main(void)
{
    v2di a = { 3, 0 };
    v2di b = { 5, 0 };
    /* pclmulqdq $0: CL_MUL(b[63:0], a[63:0]) -> 128-bit result in a. */
    asm volatile("pclmulqdq $0, %1, %0" : "+x"(a) : "x"(b));
    unsigned long long r[2];
    memcpy(r, &a, sizeof(r));
    ZASSERT(r[0] == clmul(3, 5));
    ZASSERT(r[1] == 0);

    /* Test high-half selection: imm 0x11 selects high 64 bits of both. */
    v2di c = { 0, 7 };
    v2di d = { 0, 11 };
    asm volatile("pclmulqdq $0x11, %1, %0" : "+x"(c) : "x"(d));
    unsigned long long r2[2];
    memcpy(r2, &c, sizeof(r2));
    ZASSERT(r2[0] == clmul(7, 11));
    ZASSERT(r2[1] == 0);

    return 0;
}
