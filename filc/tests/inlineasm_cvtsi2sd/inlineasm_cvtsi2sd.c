#include <stdfil.h>

int main(void)
{
    long a = 42;
    double result;

    asm volatile("cvtsi2sd %1, %0" : "=x"(result) : "r"(a));

    ZASSERT(result == 42.0);

    return 0;
}
