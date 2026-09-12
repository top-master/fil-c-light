#include <stdio.h>

extern long caller_fn(long n);

int main(void)
{
    /* n=4:
       subA call 1: r9 = 100 + (4+3+2+1) = 110
       subA call 2: r9 = 7 + (3+2+1) = 13
       subB call (direct): r9 = 13+110 wait — computed below */
    /* subB direct: r9 = 123 (from the second add) + (5+4+3+2+1) = 138 */
    long want = 110 + 13 + 138;
    long got = caller_fn(4);
    if (got != want) {
        printf("FAIL: got %ld, want %ld\n", got, want);
        return 1;
    }
    printf("sharedtail sub att ok\n");
    return 0;
}
