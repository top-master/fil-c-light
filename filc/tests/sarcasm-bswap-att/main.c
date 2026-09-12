#include <stdio.h>
#include <stdlib.h>

void bswap_round(unsigned long* p);

int main()
{
    /* bswap (64- and 32-bit) must byte-reverse the value it is given: a
       single-operand swap is a use+def of that ONE web. The old conservative
       model defined a fresh web with no use, so under register pressure the
       bswap executed on an uninitialized temp and the input value was dropped. */
    unsigned long* p = malloc(128);
    if (!p)
        return 1;
    p[0] = 0x123456789ABCDEF0UL;
    p[3] = 0x12345678UL;
    bswap_round(p);
    if (p[1] != 0xF0DEBC9A78563412UL) {
        printf("bswap64 = %lx want f0debc9a78563412\n", p[1]);
        return 1;
    }
    if (p[2] != 0x123456789ABCDEF0UL) {
        printf("bswap round-trip = %lx\n", p[2]);
        return 1;
    }
    if ((unsigned)p[3] != 0x78563412U || (p[3] >> 32) != 0) {
        printf("bswap32 = %lx\n", p[3]);
        return 1;
    }
    if (p[4] != 0x5555555555555555UL || p[5] != 0x6666666666666666UL
        || p[6] != 0x7777777777777777UL || p[7] != 0x8888888888888888UL) {
        printf("bswap pressure registers clobbered\n");
        return 1;
    }
    printf("bswap att ok\n");
    return 0;
}
