#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void cvt_ps2uqq(void* in, void* out);
void cvt_tps2udq(void* in, void* out);
void cvt_pd2udq(void* in, void* out);

/* Expected values below were cross-checked against the hardware (Zen 5)
   semantics of each instruction. */

int main()
{
    /* vcvtps2uqq: float -> u64, round-to-nearest-even. 32-byte source. */
    float* f1 = malloc(32);
    uint64_t* o1 = malloc(64);
    /* vcvttps2udq: float -> u32, truncation; negative inexact results are
       out of range for u32 -> integer indefinite 0xFFFFFFFF (SDM). */
    float* f2 = malloc(64);
    uint32_t* o2 = malloc(64);
    /* vcvtpd2udq: double -> u32, round-to-nearest-even. 64-byte source. */
    double* d3 = malloc(64);
    uint32_t* o3 = malloc(32);
    if (!f1 || !o1 || !f2 || !o2 || !d3 || !o3)
        return 1;

    f1[0] = 2.5f;                  /* -> 2 (RNE tie to even) */
    f1[1] = 3.5f;                  /* -> 4 (RNE tie to even) */
    f1[2] = 0.0f;
    f1[3] = 1.0f;
    f1[4] = 4294967296.0f;         /* 2^32 */
    f1[5] = 9007199254740992.0f;   /* 2^53 */
    f1[6] = 16.0f;
    f1[7] = 1e18f;                 /* == 999999984306749440 exactly */
    static const uint64_t e1[8] = {
        2, 4, 0, 1, 4294967296ULL, 9007199254740992ULL, 16, 999999984306749440ULL
    };
    cvt_ps2uqq(f1, o1);
    int i;
    for (i = 0; i < 8; i++) {
        if (o1[i] != e1[i]) {
            printf("ps2uqq[%d]: got %llu want %llu\n", i,
                   (unsigned long long)o1[i], (unsigned long long)e1[i]);
            return 1;
        }
    }

    f2[0] = 1.9f;                  /* -> 1 */
    f2[1] = -1.9f;                 /* -> 0xFFFFFFFF (out of range: indefinite) */
    f2[2] = -0.9f;                 /* -> 0 (truncates to -0, in range) */
    f2[3] = 0.9f;                  /* -> 0 */
    f2[4] = 4294967040.0f;         /* largest float < 2^32 */
    f2[5] = 3.7f;                  /* -> 3 */
    f2[6] = -3.7f;                 /* -> 0xFFFFFFFF */
    f2[7] = 0.0f;
    f2[8] = 100.5f;                /* -> 100 */
    f2[9] = 2.0f;
    f2[10] = 1e9f;                 /* -> 1000000000 */
    f2[11] = 2147483648.0f;        /* 2^31, in range as u32 */
    f2[12] = 4000000000.0f;
    f2[13] = 5.5f;                 /* -> 5 */
    f2[14] = -5.5f;                /* -> 0xFFFFFFFF */
    f2[15] = 1.0f;
    static const uint32_t e2[16] = {
        1, 0xFFFFFFFFu, 0, 0, 4294967040u, 3, 0xFFFFFFFFu, 0,
        100, 2, 1000000000u, 2147483648u, 4000000000u, 5, 0xFFFFFFFFu, 1
    };
    cvt_tps2udq(f2, o2);
    for (i = 0; i < 16; i++) {
        if (o2[i] != e2[i]) {
            printf("tps2udq[%d]: got %u want %u\n", i, o2[i], e2[i]);
            return 1;
        }
    }

    d3[0] = 10.5;                  /* -> 10 (RNE tie to even) */
    d3[1] = 11.5;                  /* -> 12 (RNE tie to even) */
    d3[2] = 0.9;                   /* -> 1 */
    d3[3] = 4294967295.0;          /* UINT32_MAX, in range */
    d3[4] = 3.7;                   /* -> 4 */
    d3[5] = 2.5;                   /* -> 2 */
    d3[6] = 1.4;                   /* -> 1 */
    d3[7] = 100.0;
    static const uint32_t e3[8] = { 10, 12, 1, 4294967295u, 4, 2, 1, 100 };
    cvt_pd2udq(d3, o3);
    for (i = 0; i < 8; i++) {
        if (o3[i] != e3[i]) {
            printf("pd2udq[%d]: got %u want %u\n", i, o3[i], e3[i]);
            return 1;
        }
    }

    printf("cvtuns ok\n");
    return 0;
}
