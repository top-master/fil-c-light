#include <stdio.h>
#include <stdlib.h>

/* Intel-syntax twin of sarcasm-shannot-att: `#!` annotations (label signature,
   load/store, callsite) mixed with `;!`, with marker text confined to comments
   and strings. Strings printed here match the .s payloads. */
void* slot_get(void** slot);
void slot_set(void** slot, void* v);
long load_long(long* p);
long load_semi(long* p);
long call_both(long* a, long* b);

int main()
{
    unsigned char* buf = malloc(16);
    for (int i = 0; i < 16; i++)
        buf[i] = (unsigned char)(i + 1);
    void** slot = malloc(2 * sizeof(void*));
    slot[0] = NULL;
    slot[1] = NULL;

    slot_set(&slot[0], &buf[3]);
    unsigned char* p = (unsigned char*)slot_get(&slot[0]);
    if (p != &buf[3] || *p != 4) {
        printf("shannot-int BAD\n");
        return 1;
    }
    slot_set(&slot[1], NULL);
    if (slot_get(&slot[1]) != NULL) {
        printf("shannot-int BAD null\n");
        return 1;
    }

    long a = 11, b = 22;
    printf("%ld %ld %ld\n", load_long(&a), load_semi(&b), call_both(&a, &b));
    printf("intel ;! str\n");
    printf("intel #! str\n");
    return 0;
}
