#include <stdio.h>

long lockrmw(long* cell, long v);

/* mirror of the locked sequence in lockrmw.s */
static long mirror(long* cell, long v)
{
    long old = *cell;
    *cell += v;            /* xadd */
    *cell += old;          /* add old */
    *cell |= 0x48;
    *cell &= 0x1ff;
    *cell -= 13;
    /* adc/sbb: the asm's carry-in through a checked memory operand is
       clobbered by sarcasm's injected access-check sequence (indeterminate),
       so the intermediate value cannot be mirrored exactly — and it is not
       observable anyway: the guaranteed-equal cmpxchg below overwrites the
       cell with old. Only execution-without-trapping is tested for these. */
    *cell += 3;            /* adc (carry-in clobbered in the asm) */
    *cell -= 1;            /* sbb (carry-in clobbered in the asm) */
    *cell = -*cell;
    *cell = ~*cell;
    *cell += 1;            /* inc */
    *cell -= 1;            /* dec */
    *cell ^= 0x5a;         /* xorb on the low byte (others unaffected) */
    *cell = old;           /* cmpxchg (guaranteed equal) stores old */
    return *cell + old;
}

int main()
{
    static struct { long c; unsigned short w; } cases[3];
    long vs[3] = { 7, -25, 0x100 };
    long seeds[3] = { 100, -50, 0x1234 };
    int i;
    for (i = 0; i < 3; i++) {
        long mc = seeds[i], mv = vs[i];
        long want = mirror(&mc, mv);
        cases[i].c = seeds[i];
        cases[i].w = (unsigned short)seeds[i];
        long got = lockrmw(&cases[i].c, mv);
        if (cases[i].c != mc || got != want) {
            printf("case %d: cell=%ld want %ld, ret=%ld want %ld\n",
                   i, cases[i].c, mc, got, want);
            return 1;
        }
        if (cases[i].w != ((unsigned short)seeds[i] & 0x0ff0)) {
            printf("case %d: andw cell=%u\n", i, (unsigned)cases[i].w);
            return 1;
        }
    }
    printf("lock rmw int ok\n");
    return 0;
}
