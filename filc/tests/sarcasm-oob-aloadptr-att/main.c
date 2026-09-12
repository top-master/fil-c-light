#include <stdio.h>
#include <stdlib.h>
void* f(void** p);
int main() {
    /* 16-byte object; buf+24 is past the end for an 8-byte atomic load */
    void* buf = malloc(16);
    void* p = f((void**)((char*)buf + 24));
    printf("SHOULD NOT PRINT (no oob trap): %p\n", p);
    return 0;
}
