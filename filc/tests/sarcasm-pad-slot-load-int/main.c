#include <stdio.h>

long pad_slot_load(long p);

int main()
{
    /* Intel-syntax twin of sarcasm-pad-slot-load-att. */
    unsigned long v = 0x4141414141414141UL;
    unsigned long pushed = 111;
    unsigned long expect = pushed + v + v + (v & 0xffffffffUL);
    unsigned long got = (unsigned long)pad_slot_load(0);
    if (got != expect) {
        printf("pad load = %lx want %lx\n", got, expect);
        return 1;
    }
    printf("pad load int ok\n");
    return 0;
}
