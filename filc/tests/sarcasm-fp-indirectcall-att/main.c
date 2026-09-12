#include <stdio.h>
#include <stdfil.h>

static double dfmul(double a, double b)
{
    return a * b;
}

static float fhalf(float x)
{
    return x / 2;
}

double foo1(double (*f)(double, double), double a, double b);
double foo2(double (**f)(double, double), double a, double b);
float foo3(float (*f)(float), float x);

int main()
{
    ZASSERT(foo1(dfmul, 6.0, 7.0) == 42.0);
    /* foo2 loads the callee from memory with `;! load ptr` (pointer to a
       function-pointer variable), then calls the loaded value. */
    double (*pf)(double, double) = dfmul;
    ZASSERT(foo2(&pf, 6.0, 7.0) == 42.0);
    ZASSERT(foo3(fhalf, 9.0f) == 4.5f);
    printf("fp-indirectcall ok\n");
    return 0;
}
