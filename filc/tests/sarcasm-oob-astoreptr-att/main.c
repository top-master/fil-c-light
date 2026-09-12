#include <stdio.h>
#include <stdlib.h>
void f(void** p, void* v);
int main() {
    void* buf = malloc(16);
    int x = 1;
    f((void**)((char*)buf + 24), &x);
    printf("SHOULD NOT PRINT (no oob trap)\n");
    return 0;
}
