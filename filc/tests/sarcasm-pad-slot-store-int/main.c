#include <stdio.h>

long pad_slot_store(long p);
long pad_slot_store_twice(long p);

int main()
{
    /* Intel-syntax twin of sarcasm-pad-slot-store-att. */
    if (pad_slot_store(0) != 0x4141414141414141L) {
        printf("pad store = %lx\n", (unsigned long)pad_slot_store(0));
        return 1;
    }
    if (pad_slot_store_twice(0) != 0x2222222222222222L) {
        printf("pad store twice = %lx\n", (unsigned long)pad_slot_store_twice(0));
        return 1;
    }
    printf("pad store int ok\n");
    return 0;
}
