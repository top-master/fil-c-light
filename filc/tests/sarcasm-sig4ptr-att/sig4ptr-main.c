#include <stdio.h>

long sum4p(long *a, long *b, long *c, long *d);

int main()
{
    long a = 1, b = 2, c = 4, d = 8;
    printf("%ld\n", sum4p(&a, &b, &c, &d));   /* 15 */
    printf("%ld\n", sum4p(&d, &c, &b, &a));   /* 15 */
    return 0;
}
