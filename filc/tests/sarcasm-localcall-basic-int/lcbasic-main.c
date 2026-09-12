#include <stdio.h>

extern long foo(long x);

int main(void)
{
    long r = foo(7);
    /* first call: r9 = 2*7+3 = 17; rbx = 34. second call: r9 = 2*34+3 = 71;
       result = 34 + 71 = 105. */
    if (r != 105) {
        printf("FAIL: got %ld, want 105\n", r);
        return 1;
    }
    printf("localcall basic int ok\n");
    return 0;
}
