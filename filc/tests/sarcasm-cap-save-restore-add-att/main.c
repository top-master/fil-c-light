#include <stdio.h>
#include <stdlib.h>

long cap_add_sub(unsigned long *slot, unsigned long k);
long cap_sub_add(unsigned long *slot, unsigned long k);
long cap_logic(unsigned long *slot);
long cap_shift(unsigned long *slot);
long cap_aeslike(unsigned long *slot, unsigned long k);

int main(void)
{
    /* A self-pointer slot: the loaded value is an address inside the slot's
       own object, so dereferencing it through the restored capability is
       in-bounds. The ALU math is zero-net (k added back, masked low bits
       preserved), so the restored value still points at the slot. */
    unsigned long *slot = malloc(16);
    if (!slot)
        return 1;
    *slot = (unsigned long)slot;
    if (cap_add_sub(slot, 8) != (long)slot) {
        printf("FAIL add_sub\n");
        return 1;
    }
    if (cap_sub_add(slot, 8) != (long)slot) {
        printf("FAIL sub_add\n");
        return 1;
    }
    if (cap_logic(slot) != (long)slot) {
        printf("FAIL logic\n");
        return 1;
    }
    if (cap_shift(slot) != (long)slot) {
        printf("FAIL shift\n");
        return 1;
    }
    if (cap_aeslike(slot, 5) != (long)slot) {
        printf("FAIL aeslike\n");
        return 1;
    }
    printf("cap add restore ok\n");
    return 0;
}
