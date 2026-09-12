#include <stdio.h>

extern long spill_like(long *p, long x);

int main(void)
{
    long v = 9;              /* result = *p + x*x = 9 + 25 = 34 */
    long r = spill_like(&v, 5);
    if (r != 34) {
        printf("FAIL: got %ld, want 34\n", r);
        return 1;
    }
    printf("spill push att ok\n");
    return 0;
}
