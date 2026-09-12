#include <stdio.h>

extern long frameesc(long x);

void fill32(long *p)
{
    for (int i = 0; i < 4; i++) p[i] = 100 + i;
}

int main(void)
{
    /* the helper's writes (100..103) land in the promoted frame region; the
       direct slot reads sum them (406) plus the two FP-parked lanes (7+8):
       421. */
    long r = frameesc(0);
    if (r != 421) {
        printf("FAIL: got %ld, want 421\n", r);
        return 1;
    }
    printf("frame escape region att ok\n");
    return 0;
}
