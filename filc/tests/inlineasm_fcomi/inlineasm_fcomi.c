#include <stdfil.h>

int main(void)
{
    double a = 1.0;
    double b = 2.0;
    asm volatile("fcomi" : : "t"(a), "u"(b) : "cc");
    ZASSERT(a == 1.0);
    ZASSERT(b == 2.0);

    a = 3.0;
    b = 3.0;
    asm volatile("fucomi" : : "t"(a), "u"(b) : "cc");
    ZASSERT(a == 3.0);
    ZASSERT(b == 3.0);

    a = 5.0;
    b = -1.0;
    asm volatile("fcomi" : : "t"(a), "u"(b) : "cc");
    ZASSERT(a == 5.0);
    ZASSERT(b == -1.0);

    return 0;
}
