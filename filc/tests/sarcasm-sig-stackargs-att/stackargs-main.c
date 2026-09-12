#include <stdio.h>

long sum8w(long *a, long *b, size_t n, long *c, size_t m, long *d, long *e, long *f);

int main()
{
    long a = 1, b = 2, c = 4, d = 8, e = 16, f = 32;
    /* 14 fast-CC words: args 7 and 8 (e, f) arrive as SysV stack arguments */
    long r = sum8w(&a, &b, 100, &c, 200, &d, &e, &f);  /* 1+2+100+4+200+8+16+32 = 363 */
    printf("%ld\n", r);
    return 0;
}
