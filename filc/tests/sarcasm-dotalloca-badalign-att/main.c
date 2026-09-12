#include <stdio.h>

void *dotalloca_badalign(long size, long align);

int main(void)
{
    /* 24 is not a power of two: must trap, not return a misaligned buffer. */
    volatile void *p = dotalloca_badalign(48, 24);
    printf("FAIL survived %p\n", p);
    return 1;
}
