#include <stdio.h>

/* A countdown via `loop`: the iteration count and the FINAL rcx value must
   match hardware exactly (the modeled rcx decrement must land in the physical
   rcx the instruction actually decrements). loop_count runs the body with a
   bounds-checked load inside the loop (so injected checks share the loop with
   the modeled counter); loop_rcx returns rcx after the loop exits (0 after a
   3-iteration countdown); loop_zero adds the final rcx to the iteration count
   (2 + 0). */
long loop_count(long *p), loop_rcx(long *p), loop_zero(long *p);

int main()
{
    long v = 12345;
    if (loop_count(&v) != 3) { printf("bad loop count\n"); return 1; }
    if (loop_rcx(&v) != 0) { printf("bad loop rcx\n"); return 1; }
    if (loop_zero(0) != 2) { printf("bad loop zero\n"); return 1; }
    printf("loop att ok\n");
    return 0;
}
