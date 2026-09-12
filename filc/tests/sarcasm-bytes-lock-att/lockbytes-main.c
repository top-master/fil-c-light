#include <stdio.h>

void lockadd(int* cell, long delta);
long lockone(int* cell, long v);

int main(void)
{
    /* `.byte 0xf0` + spelled cmpxchgl/addl must behave exactly like the
       spelled `lock`-prefixed forms: a locked CAS-loop counter ... */
    static int cell;
    int i;
    for (i = 0; i < 1000; i++)
        lockadd(&cell, 3);
    if (cell != 3000) {
        printf("cell=%d want 3000\n", cell);
        return 1;
    }
    /* ... and a one-shot locked cmpxchg + locked add. */
    static int c2;
    c2 = 7;
    long got = lockone(&c2, 5);
    if (c2 != 10 || got != 10) {
        printf("c2=%d got=%ld want 10\n", c2, got);
        return 1;
    }
    printf("bytes lock att ok\n");
    return 0;
}
