#include <stdfil.h>

int main(void)
{
    double a = -3.14;
    asm volatile("fchs" : "=t"(a) : "0"(a) : "fpsr");
    ZASSERT(a == 3.14);

    double b = 2.71;
    asm volatile("fchs" : "=t"(b) : "0"(b) : "fpsr");
    ZASSERT(b == -2.71);

    double c = 0.0;
    asm volatile("fchs" : "=t"(c) : "0"(c) : "fpsr");
    ZASSERT(c == 0.0);

    return 0;
}
