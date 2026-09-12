#include <stdio.h>

extern long aes_like(long x);

int main(void)
{
    /* full entry, x=5, rounds=2: acc=0; enter pass: acc=5, x=6; loop+enter
       pass: acc=23, x=7. mid entry, x=23, rounds=3 (acc persists = 23):
       pass: acc=92, x=24; pass: acc=164, x=25; pass: acc=239, x=26.
       result = 23 + 239 = 262. */
    long r = aes_like(5);
    if (r != 262) {
        printf("FAIL: got %ld, want 262\n", r);
        return 1;
    }
    printf("localcall midlabel att ok\n");
    return 0;
}
