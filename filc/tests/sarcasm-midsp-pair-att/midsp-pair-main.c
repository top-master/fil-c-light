#include <stdio.h>
extern long midsp_pair(long, long);
int main() {
    long got = midsp_pair(3, 4);
    if (got != 21) { printf("FAIL: midsp_pair(3,4) = %ld, want 21\n", got); return 1; }
    got = midsp_pair(-10, 25);
    if (got != 45) { printf("FAIL: midsp_pair(-10,25) = %ld, want 45\n", got); return 1; }
    printf("ok\n");
    return 0;
}
