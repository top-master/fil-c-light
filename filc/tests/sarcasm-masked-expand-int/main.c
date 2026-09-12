#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

/* AVX512 expand loads / compress stores with {k}: the accessed range is
   [eff, eff + popcount(mask)*E), so a full-width-OOB footprint can still be
   in bounds when the popcount range fits. */

long expand_q(void* p, long k);
long compress_q(void* p, long k);
long expand_b(void* p, long k);
long compress_b(void* p, long k);
long expand_full(void* p, long k);

static uint64_t buf[8] __attribute__((aligned(64)));
static char bbuf[64] __attribute__((aligned(64)));

int main()
{
    int i;
    for (i = 0; i < 8; i++)
        buf[i] = 200 + i;

    /* vpexpandq {z}-load at buf+56 with mask popcount 1: full footprint is
       [56, 120) — OOB — but the accessed range [56, 64) fits; lane 0 gets
       buf[7] = 207. */
    long r = expand_q((char*)buf + 56, 0x1);
    if (r != 207) {
        printf("expand_q: got %ld want 207\n", r);
        return 1;
    }

    /* vpcompressq store at buf+48 with popcount 2 (mask 0x11): accessed range
       [48, 64) fits; stores lanes 0,4 of the source (values 11, 55) to
       buf[6], buf[7]. */
    buf[6] = 0; buf[7] = 0;
    r = compress_q((char*)buf + 48, 0x11);
    if (r != 9 || buf[6] != 11 || buf[7] != 55) {
        printf("compress_q: r=%ld buf[6]=%llu buf[7]=%llu\n", r,
               (unsigned long long)buf[6], (unsigned long long)buf[7]);
        return 1;
    }

    /* byte-element forms (N=64): vpexpandb {z}-load at bbuf+63 with popcount
       1: accessed range [63, 64) fits; lane 0 gets bbuf[63] = 63. */
    for (i = 0; i < 64; i++)
        bbuf[i] = (char)i;
    r = expand_b(bbuf + 63, 0x1);
    if (r != 63) {
        printf("expand_b: got %ld want 63\n", r);
        return 1;
    }

    /* vpcompressb store at bbuf+62 with popcount 2 (mask 0x3): stores lane 0
       (=7) and lane 1 (=9) to bbuf[62], bbuf[63]. */
    bbuf[62] = 0; bbuf[63] = 0;
    r = compress_b(bbuf + 62, 0x3);
    if (r != 13 || bbuf[62] != 7 || bbuf[63] != 9) {
        printf("compress_b: r=%ld bbuf[62]=%d bbuf[63]=%d\n", r, bbuf[62], bbuf[63]);
        return 1;
    }

    /* full-mask expand at the very start (popcount 8, range [0,64)): fits. */
    for (i = 0; i < 8; i++)
        buf[i] = 300 + i;
    r = expand_full(buf, 0xFF);
    if (r != 300 + 301 + 302 + 303 + 304 + 305 + 306 + 307) {
        printf("expand_full: got %ld\n", r);
        return 1;
    }

    printf("masked expand ok\n");
    return 0;
}
