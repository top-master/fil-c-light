#include <stdio.h>
void* foo(void** p);
int main() {
    int x = 42;
    void* slot[1]; slot[0] = &x;
    void* r = foo(slot);                 // returns slot[0]'s bits with a NULL capability
    printf("deref of null-cap return (expect trap):\n");
    printf("%d SHOULD NOT PRINT\n", *(int*)r);
    return 0;
}
