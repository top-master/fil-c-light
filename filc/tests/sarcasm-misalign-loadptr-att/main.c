#include <stdio.h>
#include <stdlib.h>
void* f(void** p);
int main() {
    /* malloc'd objects are rounded up to 16 bytes, so buf+4 is in-bounds but
       8-misaligned: the pointer load must trap on alignment */
    void* buf = malloc(16);
    void* p = f((void**)((char*)buf + 4));
    printf("SHOULD NOT PRINT (no misalign trap): %p\n", p);
    return 0;
}
