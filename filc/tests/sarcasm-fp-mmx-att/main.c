#include <stdio.h>
#include <stdlib.h>

long mmx_paddd(long a, long b);
long mmx_paddw_mem(void* p);

int main()
{
    /* (2<<32)|1 + (4<<32)|3 = (6<<32)|4 = 25769803780 */
    long r1 = mmx_paddd(0x200000001L, 0x400000003L);
    /* packed words: 1..4 + 0x10..0x13... words: [1,2,3,4] + [5,6,7,8] = [6,8,10,12] */
    unsigned short* buf = malloc(16);
    if (!buf)
        return 1;
    int i;
    for (i = 0; i < 4; i++) {
        buf[i] = (unsigned short)(1 + i);
        buf[4 + i] = (unsigned short)(5 + i);
    }
    long r2 = mmx_paddw_mem(buf);
    /* [6,8,10,12] little-endian = 0x000C000A00080006 = 3377734018727942... computed below */
    long expect2 = 6L | (8L << 16) | (10L << 32) | (12L << 48);
    if (r2 != expect2)
        return 1;
    printf("mmx %ld %ld\n", r1, r2);
    return 0;
}
