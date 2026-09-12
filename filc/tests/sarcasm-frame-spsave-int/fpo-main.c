#include <stdio.h>

extern long fpo1(long x);
extern long fpo2(long x);
extern long fpo3(long x);
extern long fpo4(long x);

int main(void)
{
    long a = fpo1(10);
    long b = fpo2(7);
    long c = fpo3(21);
    long d = fpo4(100);
    if (a != 15 || b != 12 || c != 22 || d != 105) {
        printf("bad %ld %ld %ld %ld\n", a, b, c, d);
        return 1;
    }
    printf("ok\n");
    return 0;
}
