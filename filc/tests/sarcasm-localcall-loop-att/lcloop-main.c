#include <stdio.h>

extern long foo(long n);

int main(void)
{
    /* foo(n) = sum_{i=1..n} sum_{j=1..i} j = n(n+1)(n+2)/6. foo(5) = 35. */
    long r = foo(5);
    if (r != 35) {
        printf("FAIL: got %ld, want 35\n", r);
        return 1;
    }
    printf("localcall loop att ok\n");
    return 0;
}
