#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Model-checks the aesni-mb 8x re-sink branches: same C-side simulation
// discipline as sarcasm-mb-sink4x-att (prefix-xor chaining, sink-window
// predictions), but the assembly keeps output positions in frame slots
// and re-sinks via jl/jle branches every iteration.

struct mb8x_job {
    void *in[2];
    void *out[2];
    int n[2];
    unsigned char iv[2][16];
};

void mb8x_run(struct mb8x_job *job);
extern unsigned char mb8x_sink[32];

static unsigned char sentinel[16];
static int failures = 0;

static void check_mem(const void *got, const void *want, size_t len,
    const char *what) {
    if (memcmp(got, want, len) != 0) {
        printf("BAD %s\n", what);
        failures++;
    }
}

static void run_combo(int n0, int n1, int tag) {
    struct mb8x_job job;
    int ns[2] = {n0, n1};
    unsigned char *ins[2] = {NULL, NULL}, *outs[2] = {NULL, NULL};
    int max = n0 > n1 ? n0 : n1;
    for (int i = 0; i < 2; i++) {
        if (ns[i]) {
            ins[i] = malloc((size_t)ns[i] * 16);
            outs[i] = malloc((size_t)ns[i] * 16);
            for (int j = 0; j < ns[i]; j++)
                for (int k = 0; k < 16; k++)
                    ins[i][j * 16 + k] =
                        (unsigned char)(tag * 41 + i * 23 + j * 7 + k * 5 + 1);
            memset(outs[i], 0xEE, (size_t)ns[i] * 16);
        }
        job.in[i] = ins[i];
        job.out[i] = outs[i];
        job.n[i] = ns[i];
        for (int k = 0; k < 16; k++)
            job.iv[i][k] = (unsigned char)(tag * 3 + i * 11 + k * 13 + 4);
    }
    memset(mb8x_sink, 0, 16);
    memcpy(mb8x_sink + 16, sentinel, 16);
    unsigned char pre[16];
    memcpy(pre, mb8x_sink, 16);
    mb8x_run(&job);
    // Empty streams start cur = iv ^ pre (prologue placeholder = sink
    // base); live streams start cur = iv ^ in[0]. Iter j: input re-sunk
    // iff counter<=1 (load = sentinel), output re-sunk iff counter==0.
    unsigned char cur[2][16], load[16], want_sink[16];
    int have_sink = 0;
    memset(want_sink, 0, 16);
    for (int i = 0; i < 2; i++) {
        if (ns[i])
            for (int k = 0; k < 16; k++)
                cur[i][k] = job.iv[i][k] ^ ins[i][k];
        else
            for (int k = 0; k < 16; k++)
                cur[i][k] = job.iv[i][k] ^ pre[k];
    }
    unsigned char *want_out[2] = {NULL, NULL};
    for (int i = 0; i < 2; i++)
        if (ns[i])
            want_out[i] = calloc((size_t)ns[i], 16);
    for (int j = 0; j < max; j++) {
        for (int i = 0; i < 2; i++) {
            int c = (j < ns[i]) ? ns[i] - j : 0;
            if (c <= 1)
                memcpy(load, sentinel, 16);
            else
                memcpy(load, ins[i] + (j + 1) * 16, 16);
            if (c == 0) {
                memcpy(want_sink, cur[i], 16);
                have_sink = 1;
            } else
                memcpy(want_out[i] + j * 16, cur[i], 16);
            for (int k = 0; k < 16; k++)
                cur[i][k] ^= load[k];
        }
    }
    char what[128];
    for (int i = 0; i < 2; i++) {
        if (ns[i]) {
            snprintf(what, sizeof what, "tag%d stream%d live out", tag, i);
            check_mem(outs[i], want_out[i], (size_t)ns[i] * 16, what);
            free(want_out[i]);
        }
    }
    snprintf(what, sizeof what, "tag%d sink load window", tag);
    check_mem(mb8x_sink + 16, sentinel, 16, what);
    snprintf(what, sizeof what, "tag%d sink store window", tag);
    check_mem(mb8x_sink, want_sink, 16, what);
    (void)have_sink;
    free(ins[0]);
    free(ins[1]);
    free(outs[0]);
    free(outs[1]);
}

int main(void) {
    for (int k = 0; k < 16; k++)
        sentinel[k] = (unsigned char)(0xD0 + k);
    run_combo(0, 0, 1);
    run_combo(1, 1, 2);
    run_combo(4, 0, 3);
    run_combo(0, 4, 4);
    run_combo(3, 5, 5);
    run_combo(6, 6, 6);
    run_combo(1, 2, 7);
    run_combo(40, 3, 8);
    run_combo(200, 200, 9);
    if (failures == 0)
        printf("mb sink8x ok\n");
    else
        printf("mb sink8x BAD (%d)\n", failures);
    return failures != 0;
}
