#include <stdio.h>

long sum6w(long *a, long *b, size_t n, long *c, long *d, int e);

int main()
{
    long a = 1, b = 2, c = 4, d = 8;
    /* every argument must arrive intact (10 fast-CC words: 4 regs + 6 stack) */
    long r1 = sum6w(&a, &b, 100, &c, &d, 1000);   /* 1+2+100+4+8+1000 = 1115 */
    long r2 = sum6w(&d, &c, 200, &b, &a, 2000);   /* 8+4+200+2+1+2000 = 2215 */
    printf("%ld %ld\n", r1, r2);
    return 0;
}
