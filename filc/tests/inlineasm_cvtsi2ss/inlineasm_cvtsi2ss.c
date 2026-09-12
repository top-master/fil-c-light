#include <stdfil.h>

int main(void)
{
    int a = 42;
    float result;

    asm volatile("cvtsi2ss %1, %0" : "=x"(result) : "r"(a));

    ZASSERT(result == 42.0f);

    return 0;
}
