#include <stdio.h>

/* A `loop` whose back-edge target sits beyond rel8 range: the 6 bounds-checked
   loads in the body (plus the pollcheck at the back-edge label) put .Lcount
   more than 127 bytes away from the loop instruction, whose ONLY encoding is
   rel8. Sarcasm rewrites the branch through a nearby trampoline; the countdown
   must still match hardware exactly (accumulated sum + iteration count, and
   the final rcx). Hardware ground truth (plain as + gcc): loopbig=66,
   loopbig_rcx=0. */
long loopbig(long *p), loopbig_rcx(long *p);

int main()
{
    long buf[6] = {1,2,3,4,5,6};
    if (loopbig(buf) != 66) { printf("bad loop big sum\n"); return 1; }
    if (loopbig_rcx(buf) != 0) { printf("bad loop big rcx\n"); return 1; }
    printf("loop big att ok\n");
    return 0;
}
