#include <stdio.h>

long sum10p(long *a, long *b, long *c, long *d, long *e, long *f, long *g, long *h, long *i, long *j);
long caller10p(long *a, long *b, long *c, long *d, long *e, long *f, long *g, long *h, long *i, long *j);

int main()
{
    long a=1, b=2, c=4, d=8, e=16, f=32, g=64, h=128, i=256, j=512;
    long r1 = sum10p(&a,&b,&c,&d,&e,&f,&g,&h,&i,&j);    /* 1023 */
    long r2 = caller10p(&a,&b,&c,&d,&e,&f,&g,&h,&i,&j); /* 1023 */
    printf("%ld %ld\n", r1, r2);
    return 0;
}
