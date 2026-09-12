#include <stdio.h>

extern long multi_dispatch(long a, long b, long c, long d, long e, long f, long g);

int main(void)
{
    /* a=1 -> variant: 1*2*3*4*5*6*7 = 5040 (7th arg marshalled from the
       dispatcher's own incoming stack-argument slot) */
    long r1 = multi_dispatch(1, 2, 3, 4, 5, 6, 7);
    /* a=0 -> fallthrough: 0+2+3+4+5+6+7 = 27 */
    long r2 = multi_dispatch(0, 2, 3, 4, 5, 6, 7);
    if (r1 != 5040 || r2 != 27) {
        printf("FAIL: got %ld %ld\n", r1, r2);
        return 1;
    }
    printf("tailcall stackargs att ok\n");
    return 0;
}
