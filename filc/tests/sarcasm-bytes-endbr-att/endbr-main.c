#include <stdio.h>

long cetdec(long x);
long cethex(long x);
long cetmix(long x);

int main(void)
{
    /* Byte-encoded endbr64 (decimal and hex spellings) at function entry is a
       zero-effect landing pad, exactly like the spelled form. */
    long a = cetdec(40);
    long b = cethex(39);
    long c = cetmix(38);
    if (a != 42 || b != 42 || c != 42) {
        printf("bad %ld %ld %ld\n", a, b, c);
        return 1;
    }
    printf("bytes endbr att ok\n");
    return 0;
}
