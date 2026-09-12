#include <stdio.h>
#include <stdlib.h>

void movaps_misaligned(unsigned char *buf);

int main(void)
{
    /* 16-aligned buffer; the store to buf+1 is in-bounds but misaligned. */
    unsigned char *buf = aligned_alloc(16, 64);
    if (!buf)
        return 1;
    movaps_misaligned(buf + 1);
    printf("FAIL survived\n");
    return 1;
}
