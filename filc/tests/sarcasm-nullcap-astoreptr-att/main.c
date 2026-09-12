#include <stdio.h>
void f(long x, void* v);
int main() {
    int y = 1;
    printf("expect null-cap trap:\n");
    f(0x1000, &y);  // atomic store via a non-pointer int base
    printf("SHOULD NOT PRINT\n");
    return 0;
}
