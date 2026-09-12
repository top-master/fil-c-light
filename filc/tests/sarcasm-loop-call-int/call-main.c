#include <stdio.h>

/* Gap-(b)(i) probe main: the loop countdown must survive the annotated call in
   its body — the call marshals argument word 2 into dense rcx and the callee
   clobbers rcx. Pre-fix the countdown never terminated. */
long loopcall_count(long *);

int main()
{
    long r = loopcall_count(0);
    if (r != 15) { printf("bad loopcall count %ld\n", r); return 1; }
    printf("loop call int ok\n");
    return 0;
}
