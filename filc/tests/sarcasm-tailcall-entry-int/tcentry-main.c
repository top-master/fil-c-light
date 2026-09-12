#include <stdio.h>

extern long sha_dispatch(long a, long b);

int main(void)
{
    /* a=1 -> avx: 1 + 10*4 = 41 */
    long r1 = sha_dispatch(1, 4);
    /* a=0, b=3 -> ssse3: 0*3 + 7 = 7 */
    long r2 = sha_dispatch(0, 3);
    /* a=0, b=0 -> base: 0 + 2*0 = 0 */
    long r3 = sha_dispatch(0, 0);
    /* a=2, b=5 -> avx: 2 + 50 = 52 */
    long r4 = sha_dispatch(2, 5);
    if (r1 != 41 || r2 != 7 || r3 != 0 || r4 != 52) {
        printf("FAIL: got %ld %ld %ld %ld\n", r1, r2, r3, r4);
        return 1;
    }
    printf("tailcall entry int ok\n");
    return 0;
}
