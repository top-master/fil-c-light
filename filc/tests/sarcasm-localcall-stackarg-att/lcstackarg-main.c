#include <stdio.h>

extern long power_like(long *p, long a, long b, long c, long d, long e, long power);

int main(void)
{
    long base = 7;
    /* 7th arg (stack) = 5: entry read rbx=5; clone: r11=5*5=25, r10=5;
       result = *p + 5 + 25 + 5 = 42. */
    long r = power_like(&base, 1, 2, 3, 4, 5, 5);
    if (r != 42) {
        printf("FAIL: got %ld, want 42\n", r);
        return 1;
    }
    printf("localcall stackarg att ok\n");
    return 0;
}
