#include <stdio.h>
extern long midsp_loop(long);
int main() {
    /* f(n) = n*(n+1) + 7*n */
    long got = midsp_loop(10);
    if (got != 180) { printf("FAIL: midsp_loop(10) = %ld, want 180\n", got); return 1; }
    got = midsp_loop(100);
    if (got != 10800) { printf("FAIL: midsp_loop(100) = %ld, want 10800\n", got); return 1; }
    printf("ok\n");
    return 0;
}
