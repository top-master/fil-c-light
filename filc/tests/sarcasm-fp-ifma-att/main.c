#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void ifma52(void* io, void* in);

#define M52 0xFFFFFFFFFFFFFULL   /* 2^52 - 1 */

int main()
{
    /* a and b deliberately carry garbage in bits 63:52: vpmadd52* multiplies
       only the low 52 bits of each qword (SDM), and the C reference masks
       the same way. Cross-checked against Zen 5 hardware. */
    static const uint64_t avals[8] = {
        0xFF10000000000001ULL, 0xABCDEFFFFFFFFFFFULL, 0x000FFFFFFFFFFFFFULL,
        0x1230000000000000ULL, 0x8000000000000000ULL, 0x0000000000000001ULL,
        0x000ABCDEF0123456ULL, 0xFFF0000000000000ULL
    };
    static const uint64_t bvals[8] = {
        0xEE20000000000003ULL, 0x1111111111111111ULL, 0x000FFFFFFFFFFFFFULL,
        0x0000000000000002ULL, 0x000FFFFFFFFFFFFFULL, 0x1234567890ABCDEFULL,
        0x0000000000000003ULL, 0x0000000000000000ULL
    };
    static const uint64_t acc_lo[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
    static const uint64_t acc_hi[8] = { 100, 200, 300, 400, 500, 600, 700, 800 };

    uint64_t* in = malloc(64);   /* the (%rsi) source read ends exactly at the object end */
    uint64_t* io = malloc(192);
    if (!in || !io)
        return 1;
    memcpy(in, avals, 64);
    memcpy(io + 0, acc_lo, 64);
    memcpy(io + 8, acc_hi, 64);
    memcpy(io + 16, bvals, 64);

    ifma52(io, in);

    int i;
    for (i = 0; i < 8; i++) {
        unsigned __int128 prod = (unsigned __int128)(avals[i] & M52) * (bvals[i] & M52);
        uint64_t want_lo = acc_lo[i] + (uint64_t)(prod & M52);          /* luq: += (a*b) mod 2^52 */
        uint64_t want_hi = acc_hi[i] + (uint64_t)((prod >> 52) & M52);  /* huq: += floor((a*b)/2^52) mod 2^52 */
        if (io[i] != want_lo) {
            printf("luq[%d]: got %llu want %llu\n", i,
                   (unsigned long long)io[i], (unsigned long long)want_lo);
            return 1;
        }
        if (io[8 + i] != want_hi) {
            printf("huq[%d]: got %llu want %llu\n", i,
                   (unsigned long long)io[8 + i], (unsigned long long)want_hi);
            return 1;
        }
    }
    printf("ifma ok\n");
    return 0;
}
