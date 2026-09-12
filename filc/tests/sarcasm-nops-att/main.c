#include <stdio.h>

long nop_pad(long p);

int main()
{
    /* Multi-byte padding NOPs are zero-effect: they must pass through (the
       operand is a dummy encoding hint, not a memory access) instead of dying
       on the memory-width check, and the bare forms must render as something
       that assembles. */
    if (nop_pad(41) != 42) {
        printf("nop_pad = %ld\n", nop_pad(41));
        return 1;
    }
    printf("nops att ok\n");
    return 0;
}
