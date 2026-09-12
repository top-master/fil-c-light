#include <stdio.h>

extern long foo(long a, long b);

int main(void)
{
    /* a=10, b=20, slot0=5. After the sub: a=110, b=60, slot0=77.
       result = 110 + 60 + 77 = 247. */
    long r = foo(10, 20);
    if (r != 247) {
        printf("FAIL: got %ld, want 247\n", r);
        return 1;
    }
    printf("localcall frame att ok\n");
    return 0;
}
