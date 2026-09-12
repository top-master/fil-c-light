#include <stdfil.h>

int main(void)
{
    /* FJCVTZS (FEAT_JSCVT) converts a double to int32 with JavaScript
       ToInt32 semantics. Besides the converted value it writes all of
       PSTATE.NZCV: Z is set when the conversion is exact. The cset reads the
       flags the fjcvtzs left behind, so the "cc" clobber is required. (The
       double input is operand 2; outputs come first, and %d2 prints its
       d-register.) */
    double d = 4.0;
    int out;
    int zexact;
    asm volatile("fjcvtzs %w0, %d2\n\t"
                 "cset %w1, eq"
                 : "=&r"(out), "=r"(zexact)
                 : "w"(d)
                 : "cc");
    ZASSERT(out == 4);
    ZASSERT(zexact == 1);

    /* A fraction makes the conversion inexact, so Z is clear. */
    d = 4.5;
    asm volatile("fjcvtzs %w0, %d2\n\t"
                 "cset %w1, eq"
                 : "=&r"(out), "=r"(zexact)
                 : "w"(d)
                 : "cc");
    ZASSERT(out == 4);
    ZASSERT(zexact == 0);

    zprintf("fjcvtzs checksum: %d\n", out + zexact);
    return 0;
}
