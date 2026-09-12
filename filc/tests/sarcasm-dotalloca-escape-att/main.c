#include <stdio.h>
#include <stdlib.h>

unsigned long *dotalloca_makebuf(unsigned long v);

int main(void)
{
    unsigned long *buf = dotalloca_makebuf(0x4142434445464745UL);
    /* Churn the allocator so a non-rooted buffer would be collected. */
    for (int i = 0; i < 100000; i++) {
        volatile unsigned long *p = malloc(64);
        if (!p)
            return 1;
        *p = (unsigned long)i;
    }
    for (int i = 0; i < 8; i++) {
        if (buf[i] != 0x4142434445464745UL) {
            printf("FAIL escape %d %lx\n", i, buf[i]);
            return 1;
        }
    }
    printf("dotalloca escape ok\n");
    return 0;
}
