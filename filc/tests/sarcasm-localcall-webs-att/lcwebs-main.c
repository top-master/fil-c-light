#include <stdio.h>

extern long foo(long a, long b, long c);

int main(void)
{
    /* rbx = a+b; r13 = 7 + 3*(a+b); result = 3*c + r13 + (a+b).
       foo(1,2,3) = 9 + 16 + 3 = 28. */
    long r = foo(1, 2, 3);
    if (r != 28) {
        printf("FAIL: got %ld, want 28\n", r);
        return 1;
    }
    printf("localcall webs att ok\n");
    return 0;
}
