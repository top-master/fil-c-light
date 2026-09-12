#include <stdio.h>
void* f(long x);
int main() {
    printf("expect null-cap trap:\n");
    printf("%p SHOULD NOT PRINT\n", f(0x1000));  // atomic load via a non-pointer int
    return 0;
}
