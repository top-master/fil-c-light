#include <stdio.h>
extern long f(void);
int main() {
    long got = f();
    if (got != 5) { printf("FAIL: got %ld, want 5\n", got); return 1; }
    printf("ok\n");
    return 0;
}
