#include <stdio.h>

long x87_misc(long n);
long x87_cmp1(long n);

int main()
{
    printf("x87misc %ld %ld %ld %ld %ld %ld\n",
           x87_misc(5), x87_misc(-7), x87_misc(0),
           x87_cmp1(2), x87_cmp1(1), x87_cmp1(0));
    return 0;
}
