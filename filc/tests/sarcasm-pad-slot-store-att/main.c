#include <stdio.h>

long pad_slot_store(long p);
long pad_slot_store_twice(long p);

int main()
{
    /* A store to (%rsp) while `pushq %rbx` sits in the transient prologue pad
       targets the pushed register's SAVE SLOT: the pop must yield the stored
       value (real x86 semantics: the pop overwrites the register with the
       stored value and the pre-push value is lost). Sarcasm used to resurrect
       the stale pre-push value (111) here while real x86 returned
       0x4141414141414141. */
    if (pad_slot_store(0) != 0x4141414141414141L) {
        printf("pad store = %lx\n", (unsigned long)pad_slot_store(0));
        return 1;
    }
    /* Store-then-store to the same slot: the last store wins. */
    if (pad_slot_store_twice(0) != 0x2222222222222222L) {
        printf("pad store twice = %lx\n", (unsigned long)pad_slot_store_twice(0));
        return 1;
    }
    printf("pad store att ok\n");
    return 0;
}
