#include <stdio.h>

/* Drives the register-pressure asm in pressure.s: 24-ish value webs live across a
   call plus checked pointer churn, forcing the sarcasm register allocator into
   dozens of spill slots. If the allocator ever colors two simultaneously-live webs
   into one register (or leaves a web uncolored and rendered at its input register),
   the checksum perturbs and the test fails. */

__attribute__((noinline)) long sink(long x) { return x; }
long pressure(unsigned long *buf, long x);

int main(void)
{
    unsigned long buf[32];
    long got;
    for (int i = 0; i < 8; i++)
        buf[i] = 5000 + 13 * i;
    for (int i = 16; i < 24; i++)
        buf[i] = (unsigned long)(void*)&buf[i - 16];
    got = pressure(buf, 4242);
    printf("%s pressure=%ld\n", got == 341685L ? "OK" : "MISMATCH", got);
    return got == 341685L ? 0 : 1;
}
