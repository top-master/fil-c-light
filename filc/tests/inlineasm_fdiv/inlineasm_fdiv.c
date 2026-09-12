#include <stdfil.h>

int main(void)
{
    // fdiv with explicit operands: ST(0) = ST(0) / ST(1).
    double a = 6.0;
    double b = 2.0;
    double result;
    asm volatile("fdiv %%st(1), %%st" : "=t"(result) : "0"(a), "u"(b) : "fpsr");
    ZASSERT(result == 3.0);

    return 0;
}
