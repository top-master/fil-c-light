#include <stdio.h>
extern long f(long);
int main() {
    long got = f(42);
    if (got != 42) { printf("FAIL: got %ld, want 42\n", got); return 1; }
    printf("ok\n");
    return 0;
}
