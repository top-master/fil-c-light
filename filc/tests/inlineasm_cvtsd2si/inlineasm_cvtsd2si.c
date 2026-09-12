#include <stdfil.h>

int main(void)
{
    double a = 3.0;
    long result;

    asm volatile("cvtsd2si %1, %0" : "=r"(result) : "x"(a));

    ZASSERT(result == 3);

    return 0;
}
