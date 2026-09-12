#include <stdio.h>
#include <stdfil.h>

double calllocal(double a, double b);
double callext(double a, double b);
double callc(double a, double b);
double callmismatch(double a, double b);
double fplive(double a, double b);

double cfd(double a, double b)
{
    return a * b + 1.0;
}

int main()
{
    ZASSERT(calllocal(0.0, 0.0) == 42.0);
    ZASSERT(callext(0.0, 0.0) == 3.5);
    ZASSERT(callc(0.0, 0.0) == 41.0);
    ZASSERT(callmismatch(0.0, 0.0) == 5.0);
    ZASSERT(fplive(5.0, 6.0) == 217.0);
    printf("fp-asmcall ok\n");
    return 0;
}
