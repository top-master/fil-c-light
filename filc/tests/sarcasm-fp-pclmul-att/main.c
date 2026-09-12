#include <stdio.h>
#include <stdlib.h>

long pclmul_lo(long a, long b);
long pclmul_hi(long a, long b);
long pclmul_hh(long a, long b);
void sha_smoke(void* buf);

static void clmul(unsigned long a, unsigned long b, unsigned long* lo, unsigned long* hi)
{
    unsigned __int128 r = 0;
    int i;
    for (i = 0; i < 64; i++) {
        if ((b >> i) & 1)
            r ^= (unsigned __int128)a << i;
    }
    *lo = (unsigned long)r;
    *hi = (unsigned long)(r >> 64);
}

int main()
{
    /* (x^3+x+1) * (x^2+1) = x^5+x^2+x+1 = 0x27 */
    if (pclmul_lo(0xB, 0x5) != 0x27)
        return 1;
    if (pclmul_hi(0xB, 0x5) != 0)
        return 1;
    if (pclmul_hh(0xB, 0x5) != 0x27)
        return 1;
    /* cross-check against software carry-less multiply */
    unsigned long s = 0x123456789abcdef0UL;
    int i;
    for (i = 0; i < 200; i++) {
        s = s * 6364136223846793005UL + 1442695040888963407UL;
        unsigned long a = s;
        s = s * 6364136223846793005UL + 1442695040888963407UL;
        unsigned long b = s;
        unsigned long lo, hi;
        clmul(a, b, &lo, &hi);
        if (pclmul_lo(a, b) != (long)lo)
            return 1;
        if (pclmul_hi(a, b) != (long)hi)
            return 1;
    }
    /* SHA-NI smoke (outputs precomputed with intrinsics for these inputs) */
    unsigned long* buf = malloc(64);
    if (!buf)
        return 1;
    buf[0] = 0x0123456789abcdefUL; buf[1] = 0xfedcba9876543210UL;
    buf[2] = 0x0f1e2d3c4b5a6978UL; buf[3] = 0x8877665544332211UL;
    buf[4] = 0; buf[5] = 0; buf[6] = 0; buf[7] = 0;
    sha_smoke(buf);
    if (buf[4] != 0xf9c2ca3ee3e66ef0UL || buf[5] != 0x607fe204c7322b00UL)
        return 1;
    if (buf[6] != 0x536e35c2120f403fUL || buf[7] != 0xe7fc996b3f93da09UL)
        return 1;
    printf("pclmul ok\n");
    return 0;
}
