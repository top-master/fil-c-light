#include <stdio.h>
extern long foo(long);
int main() {
    printf("%ld\n", foo(0));
    printf("%ld\n", foo(41));
    return 0;
}
