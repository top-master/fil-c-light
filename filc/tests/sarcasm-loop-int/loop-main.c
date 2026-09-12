#include <stdio.h>

/* Intel-syntax countdown via `loop`: the iteration count and the final rcx
   must match hardware exactly. */
long loop_count(long *p), loop_rcx(long *p);

int main()
{
    long v = 12345;
    if (loop_count(&v) != 3) { printf("bad loop count\n"); return 1; }
    if (loop_rcx(&v) != 0) { printf("bad loop rcx\n"); return 1; }
    printf("loop int ok\n");
    return 0;
}
