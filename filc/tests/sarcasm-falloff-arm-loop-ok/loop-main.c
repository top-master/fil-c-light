#include <stdio.h>

/* count(n) counts down to 0 and returns 0: a bounded loop with a back edge and
   a conditional exit that reaches a ret -- sarcasm must compile it and it must
   actually run. spin(void) ends in an infinite loop (its only branch jumps back
   to its own loop header, so control can never fall off its end): sarcasm must
   still compile it, though this test never calls it. */
long count(long n);
void spin(void);

int main()
{
    if (count(0) != 0) { printf("bad count(0)\n"); return 1; }
    if (count(5) != 0) { printf("bad count(5)\n"); return 1; }
    if (count(1000000) != 0) { printf("bad count(1000000)\n"); return 1; }
    (void)spin; /* compiled (proving infinite-loop bodies stay accepted), never run */
    printf("ok\n");
    return 0;
}
