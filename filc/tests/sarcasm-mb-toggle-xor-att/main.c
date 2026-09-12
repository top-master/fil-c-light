#include <stdio.h>
#include <string.h>

void mbxor_run(void *src, void *dst);

// Sweep the entry rsp across 64 residues: the xor-toggle lowering is
// correct only if the output frame reproduces the governing and's
// residue for EVERY entry alignment. Any residue-dependent slip traps
// (bounds check) or swaps the halves (caught by the memcmp).
static int ok = 1;
static void run(int k) {
    volatile char wallseg[64 + (k % 64)];
    for (int i = 0; i < 64; ++i) wallseg[i] = (char)(0xA5 + i);
    __asm__ volatile("" : : "r"(&wallseg[0]) : "memory");
    if (k + 1 < 64) run(k + 1);
    unsigned char src[64], dst[64];
    for (int i = 0; i < 64; i++)
        src[i] = (unsigned char)(k * 31 + i * 3 + 7);
    memset(dst, 0, sizeof dst);
    mbxor_run(src, dst);
    ok &= (memcmp(dst, src, sizeof dst) == 0);
    for (int i = 0; i < 64; ++i) ok &= (wallseg[i] == (char)(0xA5 + i));
    __asm__ volatile("" ::: "memory");
}

int main(void) {
    run(0);
    printf("mb toggle xor %s\n", ok ? "ok" : "BAD");
    return !ok;
}
