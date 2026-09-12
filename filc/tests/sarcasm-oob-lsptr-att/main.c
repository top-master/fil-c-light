#include <stdio.h>
#include <stdlib.h>
void f(void** p, long d);
int main() {
    /* the RMW's load phase traps on the out-of-bounds slot address */
    void* buf = malloc(16);
    f((void**)((char*)buf + 24), 8);
    printf("SHOULD NOT PRINT (no oob trap)\n");
    return 0;
}
