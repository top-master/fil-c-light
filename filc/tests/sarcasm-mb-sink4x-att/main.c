#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// Model-checks the fixed aesni-mb 4x sink slide: the C side simulates the
// exact loop the assembly runs (slide, cmovge/cmovg cancels, chained xor)
// and predicts every live output block plus the final sunk-store window.
// Any addressing slip (sliding sunk addresses, overlapping windows, wrong
// cancel conditions) fails deterministically.

struct mb4x_job {
    void *in[4];
    void *out[4];
    int n[4];
    unsigned char iv[4][16];
};

void mb4x_run(struct mb4x_job *job);
extern unsigned char mbsink4[32];

static unsigned char sentinel[16];
static int failures = 0;

static void check_mem(const void *got, const void *want, size_t len,
    const char *what) {
    if (memcmp(got, want, len) != 0) {
        printf("BAD %s\n", what);
        failures++;
    }
}

// Simulate one combo; returns 1 if all predictions matched.
static void run_combo(int n0, int n1, int n2, int n3, int tag) {
    struct mb4x_job job;
    int ns[4] = {n0, n1, n2, n3};
    unsigned char *ins[4], *outs[4];
    int max = 0;
    for (int i = 0; i < 4; i++) {
        if (ns[i] > max)
            max = ns[i];
        ins[i] = ns[i] ? malloc((size_t)ns[i] * 16) : NULL;
        outs[i] = ns[i] ? malloc((size_t)ns[i] * 16) : NULL;
        for (int j = 0; j < ns[i]; j++)
            for (int k = 0; k < 16; k++)
                ins[i][j * 16 + k] =
                    (unsigned char)(tag * 31 + i * 17 + j * 5 + k * 3 + 1);
        if (outs[i])
            memset(outs[i], 0xEE, (size_t)ns[i] * 16);
        job.in[i] = ins[i];
        job.out[i] = outs[i];
        job.n[i] = ns[i];
        for (int k = 0; k < 16; k++)
            job.iv[i][k] = (unsigned char)(tag + i * 13 + k * 7 + 2);
    }
    // Reset the sink: store window zeroed, load window sentinel.
    memset(mbsink4, 0, 16);
    memcpy(mbsink4 + 16, sentinel, 16);
    unsigned char pre[16];
    memcpy(pre, mbsink4, 16);
    mb4x_run(&job);
    // Predict: cur[i] starts iv[i]^in[i][0] for live streams. For empty
    // streams the prologue placeholder is the sink BASE (the .pl's
    // `leaq sink; cmovle %rbp` with no +16 bias), so the initial dummy
    // load reads the store window's pre-call content (zeroed above).
    unsigned char cur[4][16], load[16], want_sink[16];
    int have_sink = 0;
    memset(want_sink, 0, 16);
    for (int i = 0; i < 4; i++) {
        if (ns[i])
            for (int k = 0; k < 16; k++)
                cur[i][k] = job.iv[i][k] ^ ins[i][k];
        else
            for (int k = 0; k < 16; k++)
                cur[i][k] = job.iv[i][k] ^ pre[k];
    }
    unsigned char (*want_out[4]) = {NULL, NULL, NULL, NULL};
    for (int i = 0; i < 4; i++)
        if (ns[i])
            want_out[i] = calloc((size_t)ns[i], 16);
    for (int j = 0; j < max; j++) {
        for (int i = 0; i < 4; i++) {
            int c = (j < ns[i]) ? ns[i] - j : 0;
            int in_sunk = (c <= 1);
            int out_sunk = (c == 0);
            if (in_sunk)
                memcpy(load, sentinel, 16);
            else
                memcpy(load, ins[i] + (j + 1) * 16, 16);
            if (out_sunk) {
                memcpy(want_sink, cur[i], 16);
                have_sink = 1;
            } else
                memcpy(want_out[i] + j * 16, cur[i], 16);
            for (int k = 0; k < 16; k++)
                cur[i][k] ^= load[k];
        }
    }
    char what[128];
    for (int i = 0; i < 4; i++) {
        if (ns[i]) {
            snprintf(what, sizeof what, "tag%d stream%d live out", tag, i);
            check_mem(outs[i], want_out[i], (size_t)ns[i] * 16, what);
            free(want_out[i]);
        }
    }
    // Load window must be pristine: dummy loads never disturb it, and no
    // dummy store may overlap it (disjoint 16B windows).
    snprintf(what, sizeof what, "tag%d sink load window", tag);
    check_mem(mbsink4 + 16, sentinel, 16, what);
    // Store window: last sunk store, or zero if nothing ever sank.
    snprintf(what, sizeof what, "tag%d sink store window", tag);
    if (have_sink)
        check_mem(mbsink4, want_sink, 16, what);
    else
        check_mem(mbsink4, want_sink, 16, what);
    for (int i = 0; i < 4; i++) {
        free(ins[i]);
        free(outs[i]);
    }
}

int main(void) {
    for (int k = 0; k < 16; k++)
        sentinel[k] = (unsigned char)(0xC0 + k);
    run_combo(0, 0, 0, 0, 1);
    run_combo(1, 1, 1, 1, 2);
    run_combo(3, 1, 0, 2, 3);
    run_combo(5, 5, 5, 5, 4);
    run_combo(2, 0, 0, 0, 5);
    run_combo(1, 0, 0, 0, 6);
    run_combo(0, 7, 0, 3, 7);
    run_combo(9, 8, 7, 6, 8);
    run_combo(16, 16, 0, 16, 9);
    run_combo(100, 100, 100, 100, 10);
    // Long runs: with the old sliding form these need 16*num+16 bytes of
    // sink (300 blocks = 4816B > 4096, guaranteed OOB); with the constant
    // form the same 32B object covers any count.
    run_combo(300, 0, 0, 0, 11);
    run_combo(0, 0, 300, 1, 12);
    run_combo(1000, 2, 0, 500, 13);
    if (failures == 0)
        printf("mb sink4x ok\n");
    else
        printf("mb sink4x BAD (%d)\n", failures);
    return failures != 0;
}
