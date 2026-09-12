#include <stdio.h>

extern long foo(long x);

int main(void)
{
    /* helper(x, x+5) = 4*(2*x+5); foo(x) = that + 1. foo(10) = 4*25+1 = 101 */
    long r = foo(10);
    if (r != 101) {
        printf("FAIL: got %ld, want 101\n", r);
        return 1;
    }
    printf("localcall type-function att ok\n");
    return 0;
}
