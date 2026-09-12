#include <stdio.h>
#include <stdlib.h>

/* The .s file exercises ARM64 `#` comments: a top-level plain note, a cpp
   linemarker, an in-body comment whose text contains marker text, and a
   trailing comment after a label -- all inert, with `//!`/`;!` annotations
   still working everywhere. */
void* slot_get(void** slot);
void slot_set(void** slot, void* v);
long load_long(long* p);
long load_semi(long* p);
long call_both(long* a, long* b);
long choose(long* p, long flag);

int main()
{
    unsigned char* buf = malloc(16);
    for (int i = 0; i < 16; i++)
        buf[i] = (unsigned char)(i + 1);
    void** slot = malloc(2 * sizeof(void*));
    slot[0] = NULL;
    slot[1] = NULL;

    /* capability round-trip through //! store ptr / //! load ptr */
    slot_set(&slot[0], &buf[3]);
    unsigned char* p = (unsigned char*)slot_get(&slot[0]);
    if (p != &buf[3] || *p != 4) {
        printf("hash-comment-arm BAD\n");
        return 1;
    }
    slot_set(&slot[1], NULL);
    if (slot_get(&slot[1]) != NULL) {
        printf("hash-comment-arm BAD null\n");
        return 1;
    }

    long a = 11, b = 22;
    printf("%ld %ld %ld %ld %ld\n", load_long(&a), load_semi(&b),
           call_both(&a, &b), choose(&a, 1), choose(&b, 0));
    return 0;
}
