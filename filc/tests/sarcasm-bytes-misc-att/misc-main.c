#include <stdio.h>

long cdqeb(long x);
long miscb(long x);

int main(void)
{
    /* 48 98 = cdqe: the sign extension must really happen. */
    if (cdqeb(-19) != -19 || cdqeb(42) != 42) {
        printf("cdqe bad %ld %ld\n", cdqeb(-19), cdqeb(42));
        return 1;
    }
    /* 0f 01 d0 = xgetbv (XCR0&1 must be 1), 49 0f c7 f2 = rdrand %r10,
       49 0f c7 fa = rdseed %r10 (masked to nothing; only not trapping is
       asserted). miscb(x) = 1 + 2*x. */
    long got = miscb(21);
    if (got != 43) {
        printf("miscb = %ld want 43\n", got);
        return 1;
    }
    printf("bytes misc att ok\n");
    return 0;
}
