#include <stdio.h>

/* f_frame(a, b) = (b + 100) + trunc(a + 0.5) + trunc(b + 0.25) + trunc(5.0)
   + (GPR-alias diffs of the spilled q slot, always 0):
   f_frame(3, 12) = 112 + 3 + 12 + 5 = 132; f_frame(10, 20) = 120 + 10 + 20 + 5 = 155. */
long f_frame(long a, long b);

int main()
{
    double keep8 = 1.5, keep9 = -2.5;   /* may land in d8/d9 across the call */
    long r1 = f_frame(3, 12);
    long r2 = f_frame(10, 20);
    if (keep8 != 1.5 || keep9 != -2.5) {
        printf("callee-saved d8/d9 clobbered\n");
        return 1;
    }
    printf("frame %ld %ld\n", r1, r2);
    return 0;
}
