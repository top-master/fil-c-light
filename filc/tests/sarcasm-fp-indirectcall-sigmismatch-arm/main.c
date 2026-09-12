#include <stdio.h>
#include <stdfil.h>

static double dcal(double x)
{
    return x + x;
}

static float fcal(float x)
{
    return x + x;
}

long dbar(double (*f)(double), long seed, double v);
long fbar(float (*f)(float), double v);

int main()
{
    /* dcal receives the seed's bit pattern (1.0) and returns 2.0. */
    ZASSERT(dbar(dcal, 0x3FF0000000000000L, 3.25) == 2);
    /* fcal receives the low 4 bytes of 0.5's double bit pattern (0.0f) and
       returns 0.0f. */
    ZASSERT(fbar(fcal, 0.5) == 0);
    printf("fp-indirectcall-sigmismatch ok\n");
    return 0;
}
