#include <stdio.h>

long pad_two(long p);

int main()
{
    /* A two-register pad: the FIRST push sits at the higher address, so
       (%rsp) is the second push's save slot and 8(%rsp) is the first push's;
       16(%rsp) is a plain frame slot (neither save slot) and must stay one. */
    unsigned long expect = 7UL + 0x2222222222222222UL + 0x1111111111111111UL;
    unsigned long got = (unsigned long)pad_two(7);
    if (got != expect) {
        printf("pad two = %lx want %lx\n", got, expect);
        return 1;
    }
    printf("pad two att ok\n");
    return 0;
}
