#include <stdio.h>
#include <stdfil.h>

double dmul(double a, double b);
float fadd2(float a, float b);
double dmix(int a, double b);
long mixed(double a, int b, float c, long d);
float fconst(void);
void recordf(float f, double d);
void rec(long v);

static long g_value = -1;
void rec(long v) { g_value = v; }

int main()
{
    ZASSERT(dmul(6.0, 7.0) == 42.0);
    ZASSERT(fadd2(1.5f, 2.25f) == 3.75f);
    ZASSERT(dmix(7, 1.5) == 10.5);
    ZASSERT(mixed(1.5, 20, 3.5, 40) == 140);
    ZASSERT(fconst() == 2.5f);
    recordf(3.5f, 6.5);
    ZASSERT(g_value == 24);
    printf("fp-args ok\n");
    return 0;
}
