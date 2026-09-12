#include <stdio.h>
extern long midsp_multi(long);
int main() {
    long got = midsp_multi(10);
    if (got != 86) { printf("FAIL: midsp_multi(10) = %ld, want 86\n", got); return 1; }
    got = midsp_multi(-5);
    if (got != -34) { printf("FAIL: midsp_multi(-5) = %ld, want -34\n", got); return 1; }
    printf("ok\n");
    return 0;
}
