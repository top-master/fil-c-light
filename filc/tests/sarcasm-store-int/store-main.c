#include <stdio.h>
#include <stdlib.h>
void store_ptr(void** p, void* v);
int main() {
    void** slot = malloc(sizeof(void*));
    int* obj = malloc(sizeof(int)); *obj = 12345;
    store_ptr(slot, obj);        // *slot = obj  (capability must be preserved)
    int* back = (int*)*slot;
    printf("%d\n", *back);       // 12345 if the pointer capability round-trips
    return 0;
}
