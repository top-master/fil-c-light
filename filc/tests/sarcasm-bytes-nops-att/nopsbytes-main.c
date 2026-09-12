#include <stdio.h>

long npad(long x);

int main(void)
{
    /* Byte-encoded padding nops (0x0f,0x1f,0x00 and lone 0x66/0x67/0x3e
       fillers) are zero-effect: npad(x) = x + 42. */
    if (npad(0) != 42 || npad(-42) != 0) {
        printf("npad bad %ld %ld\n", npad(0), npad(-42));
        return 1;
    }
    printf("bytes nops att ok\n");
    return 0;
}
