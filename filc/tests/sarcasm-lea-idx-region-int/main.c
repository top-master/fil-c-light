#include <stdio.h>

long leaidx_single(long i);
long leaidx_two(long i);

int main(void)
{
    for (long i = 0; i < 4; i++) {
        long s = leaidx_single(i);
        long t = leaidx_two(i);
        if (s != 100 + i || t != 100 + i) {
            printf("FAIL i=%ld single=%ld two=%ld\n", i, s, t);
            return 1;
        }
    }
    printf("lea idx region int ok\n");
    return 0;
}
