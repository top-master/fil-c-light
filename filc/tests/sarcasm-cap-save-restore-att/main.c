#include <stdio.h>
#include <stdlib.h>

long cap_basic(unsigned long *slot);
long cap_alu(unsigned long *slot, unsigned long k);

int main(void)
{
    /* A self-pointer slot: the loaded value is an address inside the slot's
       own object, so dereferencing it through the slot's (restored)
       capability is in-bounds. */
    unsigned long *slot = malloc(16);
    if (!slot)
        return 1;
    *slot = (unsigned long)slot;
    long v = cap_basic(slot);
    if (v != (long)slot) {
        printf("FAIL basic %lx vs %p\n", v, (void *)slot);
        return 1;
    }
    v = cap_alu(slot, 0);
    if (v != (long)slot) {
        printf("FAIL alu %lx vs %p\n", v, (void *)slot);
        return 1;
    }
    printf("cap save restore ok\n");
    return 0;
}
