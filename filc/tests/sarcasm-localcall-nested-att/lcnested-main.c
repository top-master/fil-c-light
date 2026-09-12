#include <stdio.h>

extern long foo(long x);

int main(void)
{
    /* sub_a(x) = 2*x + (x+100) = 3*x+100.
       foo(5): first call r9 = 115 (r12 = 115, r10 = 230); second call
       r9 = 3*230+100 = 790; result = 115 + 790 = 905. */
    long r = foo(5);
    if (r != 905) {
        printf("FAIL: got %ld, want 905\n", r);
        return 1;
    }
    printf("localcall nested att ok\n");
    return 0;
}
