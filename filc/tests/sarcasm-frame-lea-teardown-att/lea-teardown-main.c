#include <stdio.h>

extern long lea1(long x);
extern long lea2(long x);

int main(void)
{
    long a = lea1(11);
    long b = lea2(10);
    if (a != 40 || b != 59) {
        printf("bad %ld %ld\n", a, b);
        return 1;
    }
    printf("ok\n");
    return 0;
}
