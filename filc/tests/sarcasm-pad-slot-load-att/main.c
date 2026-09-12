#include <stdio.h>

long pad_slot_load(long p);

int main()
{
    /* Loading the pushed register's save slot inside the pad: before any store
       it reads the PUSHED value (111); after the store it reads the stored
       value (8 bytes) or its low 4 bytes (a narrow load). */
    unsigned long v = 0x4141414141414141UL;
    unsigned long pushed = 111;
    unsigned long expect = pushed + v + v + (v & 0xffffffffUL);
    unsigned long got = (unsigned long)pad_slot_load(0);
    if (got != expect) {
        printf("pad load = %lx want %lx\n", got, expect);
        return 1;
    }
    printf("pad load att ok\n");
    return 0;
}
