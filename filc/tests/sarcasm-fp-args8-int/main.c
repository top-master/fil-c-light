#include <stdio.h>
#include <stdfil.h>

double f8(double a, double b, double c, double d, double e, double f, double g,
          double h);
double call8(double a);
double ind8(double (*fn)(double, double, double, double, double, double, double, double),
            double a, double b, double c, double d, double e, double f, double g,
            double h);
double ind8generic(double (*fn)(double, double, double, double, double, double, double, double),
                   double a, double b, double c, double d, double e, double f, double g,
                   double h, int extra);

/* f8 computes sum(k * a_k). */
int main()
{
    /* callsite thunk (fast path): 1 + 2*2 + ... + 8*8 = 204 */
    ZASSERT(call8(1.0) == 204.0);
    /* inline indirect call, matching sig (fast path): sum(k*(k+.5)) = 204 + 18 = 222 */
    ZASSERT(ind8(f8, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5) == 222.0);
    /* inline indirect call, mismatched sig (generic buffer path): sum(k*.25k) = 51;
       the extra int argument is stored past the words the callee reads */
    ZASSERT(ind8generic(f8, 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 7) == 51.0);
    printf("fp-args8 ok\n");
    return 0;
}
