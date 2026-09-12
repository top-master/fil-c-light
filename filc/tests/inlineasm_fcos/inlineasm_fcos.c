#include <math.h>
#include <stdfil.h>

int main(void)
{
    double a = 0.0;
    asm volatile("fcos" : "=t"(a) : "0"(a) : "fpsr");
    ZASSERT(a == 1.0);

    double b = 1.0;
    asm volatile("fcos" : "=t"(b) : "0"(b) : "fpsr");
    ZASSERT(b > 0.54);
    ZASSERT(b < 0.55);

    double c = -1.0;
    asm volatile("fcos" : "=t"(c) : "0"(c) : "fpsr");
    ZASSERT(c > 0.54);
    ZASSERT(c < 0.55);

    return 0;
}
