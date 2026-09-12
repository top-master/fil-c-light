/* fnoneon(d, n) must return d unchanged: the original d0 survives n loop
   iterations (each planting a pollcheck whose slow path is an injected
   runtime call that clobbers caller-saved vector registers) and the call to
   fecho, all in a function body that never names a NEON register. Runs
   under all four GC modes; gcstress fires the pollcheck slow path on every
   iteration, so an unsaved d0 comes back garbage. fnloop exercises the
   GPR-only helper loop (x-regs only, no FP anywhere). */
#include <stdio.h>
#include <stdfil.h>

double fnoneon(double d, long n);
long fnloop(long n);
void grecord(long x);

static long g_sink;
void grecord(long x) { g_sink += x; }

int main()
{
    ZASSERT(fnoneon(42.5, 0) == 42.5);
    ZASSERT(fnoneon(42.5, 8) == 42.5);
    ZASSERT(fnoneon(-1.75, 100000) == -1.75);
    ZASSERT(fnloop(5) == 5);
    ZASSERT(g_sink == 25);
    printf("fp-live-noneon ok\n");
    return 0;
}
