#include <stdfil.h>

int main(void)
{
    /* fjcvtzs writes PSTATE.NZCV (Z = conversion was exact) but the "cc"
       clobber is missing. */
    double d = 4.0;
    int out;
    int zexact;
    asm volatile("fjcvtzs %w0, %d2\n\t"
                 "cset %w1, eq"
                 : "=&r"(out), "=r"(zexact)
                 : "w"(d));
    zprintf("not reached %d %d\n", out, zexact);
    return 0;
}
