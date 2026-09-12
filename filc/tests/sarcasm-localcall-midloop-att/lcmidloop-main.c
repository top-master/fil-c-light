#include <stdio.h>

extern long midloop_like(long x);

int main(void)
{
    /* full entry, x=2, rounds=2, step=2: acc=0; inner: acc=2; enter: acc=3,
       r10=1; loop: acc=103; inner: acc=105; enter: acc=106, r10=0; final:
       acc=113. mid entry, r9=113, rounds=2, step=2 (acc persists): enter:
       acc=114, r10=1; loop: acc=214; inner: acc=216; enter: acc=217, r10=0;
       final: acc=224. result = 113 + 224 = 337. */
    long r = midloop_like(2);
    if (r != 337) {
        printf("FAIL: got %ld, want 337\n", r);
        return 1;
    }
    printf("localcall midloop att ok\n");
    return 0;
}
