#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Two streams share one 32B sink. Pre-fill BOTH windows with distinct
// patterns and check after the run: the load window must be bit-identical
// (dummy stores can never bleed into it), the store window must hold the
// last sunk store (or the pre-fill if nothing ever sank, proving live
// stores never touch the sink either).

struct mbsh_job {
    void *in[2];
    void *out[2];
    int n[2];
};

void mbsh_run(struct mbsh_job *job);
extern unsigned char mbsh_sink[32];

static const uint64_t K0 = 0x0F0E0D0C0B0A0908ULL;
static const uint64_t K1 = 0x8070605040302010ULL;
static int failures = 0;

static void run_case(int n0, int n1, int tag) {
    struct mbsh_job job;
    int ns[2] = {n0, n1};
    unsigned char *ins[2] = {NULL, NULL}, *outs[2] = {NULL, NULL};
    int max = n0 > n1 ? n0 : n1;
    for (int i = 0; i < 2; i++) {
        if (ns[i]) {
            ins[i] = malloc((size_t)ns[i] * 16);
            outs[i] = malloc((size_t)ns[i] * 16);
            for (int j = 0; j < ns[i] * 16; j++)
                ins[i][j] = (unsigned char)(tag * 37 + i * 19 + j * 2 + 1);
            memset(outs[i], 0xEE, (size_t)ns[i] * 16);
        }
        job.in[i] = ins[i];
        job.out[i] = outs[i];
        job.n[i] = ns[i];
    }
    // Distinct pre-fill: store window 0xA*, load window 0xB*.
    for (int k = 0; k < 16; k++) {
        mbsh_sink[k] = (unsigned char)(0xA0 + k);
        mbsh_sink[16 + k] = (unsigned char)(0xB0 + k);
    }
    mbsh_run(&job);
    // Predict live outputs. The model keeps the real .pl indexing: iter j
    // (offset 16*(j+1)) loads the NEXT block in[j+1] and stores the
    // current result to out[j]. The load is sunk exactly when
    // counter<=1, i.e. for the last live block j==n-1, so the last live
    // store carries (sentinel^K) -- observable proof the next-block load
    // was dummy-cancelled instead of reading one-past-the-end. The
    // sentinel is the known pre-fill (byte k = 0xB0+k), independent of
    // the post-run window check below.
    unsigned char sent[16];
    for (int k = 0; k < 16; k++)
        sent[k] = (unsigned char)(0xB0 + k);
    uint64_t sq0, sq1;
    memcpy(&sq0, sent, 8);
    memcpy(&sq1, sent + 8, 8);
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < ns[i]; j++) {
            uint64_t lo, hi, want_lo, want_hi;
            if (j == ns[i] - 1) {
                want_lo = sq0 ^ K0;
                want_hi = sq1 ^ K1;
            } else {
                memcpy(&lo, ins[i] + (j + 1) * 16, 8);
                memcpy(&hi, ins[i] + (j + 1) * 16 + 8, 8);
                want_lo = lo ^ K0;
                want_hi = hi ^ K1;
            }
            if (memcmp(outs[i] + j * 16, &want_lo, 8) != 0
                || memcmp(outs[i] + j * 16 + 8, &want_hi, 8) != 0) {
                printf("BAD tag%d stream%d block%d live\n", tag, i, j);
                failures++;
            }
        }
    }
    // Load window must be exactly the pre-fill: every sunk load read it
    // and no sunk store may overlap it.
    for (int k = 0; k < 16; k++) {
        if (mbsh_sink[16 + k] != (unsigned char)(0xB0 + k)) {
            printf("BAD tag%d load window byte %d: 0x%02x\n",
                tag, k, mbsh_sink[16 + k]);
            failures++;
        }
    }
    // Store window: last sunk store, or pre-fill when nothing sank.
    // A sunk store writes (S0^K0,S1^K1) where S0/S1 are the sentinel
    // qwords (known pre-fill; the load window is proven intact below).
    uint64_t s0 = sq0, s1 = sq1;
    uint64_t want0 = s0 ^ K0, want1 = s1 ^ K1;
    int any_sunk = (n0 != max) || (n1 != max) || max == 0;
    // (streams shorter than max sink at least once; equal streams still
    // sink their next-block loads... but those never STORE sunk. Only a
    // stream with n<max, or... hmm: a stream with n==max stores live
    // every iter, so with n0==n1==max nothing stores sunk.)
    int stores_sunk = (n0 < max) || (n1 < max);
    (void)any_sunk;
    if (stores_sunk) {
        if (memcmp(mbsh_sink, &want0, 8) != 0
            || memcmp(mbsh_sink + 8, &want1, 8) != 0) {
            printf("BAD tag%d store window\n", tag);
            failures++;
        }
    } else {
        for (int k = 0; k < 16; k++) {
            if (mbsh_sink[k] != (unsigned char)(0xA0 + k)) {
                printf("BAD tag%d store window clobbered live\n", tag);
                failures++;
                break;
            }
        }
    }
    free(ins[0]);
    free(ins[1]);
    free(outs[0]);
    free(outs[1]);
}

int main(void) {
    run_case(0, 0, 1);      // no iterations at all
    run_case(1, 0, 2);      // stream 1 fully sunk
    run_case(0, 1, 3);      // stream 0 fully sunk
    run_case(4, 4, 4);      // all live: sink must stay pre-filled
    run_case(5, 2, 5);      // mixed lengths
    run_case(1, 1, 6);
    run_case(500, 0, 7);    // long fully-sunk run on one side
    run_case(0, 500, 8);
    run_case(17, 16, 9);    // off-by-one lengths
    if (failures == 0)
        printf("mb sink shared ok\n");
    else
        printf("mb sink shared BAD (%d)\n", failures);
    return failures != 0;
}
