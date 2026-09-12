#include <stdio.h>
int deref_int(long x);
int main() {
    printf("expect null-cap trap:\n");
    printf("%d SHOULD NOT PRINT\n", deref_int(0x1000));  // deref of a non-pointer int
    return 0;
}
