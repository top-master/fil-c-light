#include <stdio.h>
void* bar(void** p);
int main() {
    int x = 42;
    void* slot[1]; slot[0] = &x;
    int* r = (int*)bar(slot);            // returns slot[0] with its real capability
    printf("%d\n", *r);                  // expect 42
    return 0;
}
