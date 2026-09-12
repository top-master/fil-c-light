#include <stdio.h>

long cfunc(long x) { return x * 10 + 1; }

extern long foo(long x);

int main(void)
{
    /* wrap(x) = 2*cfunc(x) = 2*(10x+1). foo(4): wrap(4) = 82; wrap(84) =
       2*841 = 1682; result = 82 + 1682 = 1764. */
    long r = foo(4);
    if (r != 1764) {
        printf("FAIL: got %ld, want 1764\n", r);
        return 1;
    }
    printf("localcall callinside att ok\n");
    return 0;
}
