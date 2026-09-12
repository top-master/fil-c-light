#include <stdio.h>
long f(long a, long b);
int main() {
    // gcc -O0 leaf shape: no subq, spills land in the red zone via -8/-16(%rbp)
    // (rbp == rsp here, so these are the same red zone -8/-16(%rsp) would be).
    printf("%ld\n", f(40, 63));
    return 0;
}
