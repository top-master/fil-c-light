#include <stdio.h>

long repret(long x);
long repret2(long x);

int main(void)
{
    /* Functions ending in `.byte 0xf3,0xc3` (rep ret) after a real frame must
       return through the frame teardown exactly like a spelled `ret`. */
    long a = repret(35);
    long b = repret2(17);
    if (a != 42 || b != 22) {
        printf("bad %ld %ld\n", a, b);
        return 1;
    }
    printf("bytes repret att ok\n");
    return 0;
}
