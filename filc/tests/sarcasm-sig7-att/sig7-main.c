#include <stdio.h>

long sum7w(long *a, long *b, long *c, long *d, long *e, long *f, int m);

int main()
{
    long a = 1, b = 2, c = 4, d = 8, e = 16, f = 32;
    /* 13 fast-CC words; arg 7 (m) is read via movd 8(%rsp),%xmm5 at entry */
    long r = sum7w(&a, &b, &c, &d, &e, &f, 2000);  /* 1+2+4+8+16+32+2000 = 2063 */
    printf("%ld\n", r);
    return 0;
}
