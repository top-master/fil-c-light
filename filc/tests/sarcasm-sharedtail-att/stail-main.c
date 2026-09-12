#include <stdio.h>

extern long mul_op(long a, long b);
extern long sqr_op(long a);

static long mix(long x) { return x + (x >> 8); }

int main(void)
{
    long r1 = mul_op(1000, 7);    /* 7000, mixed */
    long r2 = sqr_op(123);        /* 15129, mixed */
    long r3 = mul_op(5, 9);
    if (r1 != mix(7000) || r2 != mix(15129) || r3 != mix(45)) {
        printf("FAIL: got %ld %ld %ld, want %ld %ld %ld\n",
               r1, r2, r3, mix(7000), mix(15129), mix(45));
        return 1;
    }
    printf("sharedtail att ok\n");
    return 0;
}
