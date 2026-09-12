#include <stdio.h>
#include <stdlib.h>
void* f(void** p);
int main() {
    void* buf = malloc(16);
    void* p = f((void**)((char*)buf + 4));
    printf("SHOULD NOT PRINT (no misalign trap): %p\n", p);
    return 0;
}
