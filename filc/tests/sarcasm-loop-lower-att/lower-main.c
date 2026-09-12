#include <stdio.h>

/* Gap-(a) probe main: the counter is defined while arg1's capability lower
   (dense rcx) is live, and a checked load through arg1 follows the definition.
   Pre-fix the coalesced lower was destroyed by the counter's movq and the
   bounds check read the counter as the lower (SIGSEGV). */
long lowerlive_count(long *, long *);

int main()
{
    long a[4] = { 7, 7, 7, 7 };
    long b[4] = { 5, 5, 5, 5 };
    long r = lowerlive_count(a, b);
    if (r != 7 + 4 * 5) { printf("bad lowerlive count %ld\n", r); return 1; }
    printf("loop lower att ok\n");
    return 0;
}
