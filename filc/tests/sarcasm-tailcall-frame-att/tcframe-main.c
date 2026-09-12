#include <stdio.h>

extern long framed_dispatch(long a, long b);

static long g1, g2, g3, g4;

int main(void)
{
    /* a=10,b=3 -> deep_variant: 10-3 = 7 (jump taken at frame depth 40) */
    long r1 = framed_dispatch(10, 3);
    /* a=0,b=9 -> fallthrough: 0 + 9 + (0+9) + 3*0 = 18 */
    long r2 = framed_dispatch(0, 9);
    /* keep values live across the calls in the caller's callee-saved regs:
       if the asm clobbered them, the sums below go wrong */
    g1 = r1; g2 = r2;
    long r3 = framed_dispatch(5, 5);   /* -> deep_variant: 0 */
    long r4 = framed_dispatch(0, 1);   /* fallthrough: 0+1+1+0 = 2 */
    g3 = r3; g4 = r4;
    if (g1 != 7 || g2 != 18 || g3 != 0 || g4 != 2) {
        printf("FAIL: got %ld %ld %ld %ld\n", g1, g2, g3, g4);
        return 1;
    }
    printf("tailcall frame att ok\n");
    return 0;
}
