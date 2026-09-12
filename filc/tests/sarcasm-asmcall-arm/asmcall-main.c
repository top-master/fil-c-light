#include <stdio.h>

/* Multiple .s files in one test: sumsq (in combine.s) calls square (in arith.s),
   a cross-translation-unit asm->asm call through the callsite resolver. arith.s
   also defines two same-signature functions in one module. */
long square(long x);
long cube(long x);
long sumsq(long a, long b);

int main()
{
    printf("%ld %ld %ld\n", square(7), cube(3), sumsq(3, 4));
    return 0;
}
