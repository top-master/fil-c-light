#include <stdio.h>

/* sumto(n) = 1 + 2 + ... + n for n >= 1, else 0. The asm uses GNU-as numeric
   local labels: `jg 1f` branches forward to the `1:` loop prologue when n > 0,
   and `jle 2b` is the backward loop edge (which must also register as a CFG
   back-edge so sarcasm inserts its loop pollcheck). */
long sumto(long n);

int main()
{
    printf("sumto(10) = %ld\n", sumto(10));    /* 55, loop via 2b */
    printf("sumto(-3) = %ld\n", sumto(-3));    /* 0, forward 1f branch not taken */
    printf("sumto(1) = %ld\n", sumto(1));      /* 1 */
    printf("sumto(100) = %ld\n", sumto(100));  /* 5050 */
    return 0;
}
