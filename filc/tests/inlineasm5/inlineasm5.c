#include <stdfil.h>

int foo(int x)
{
    int y = x + 5;
    asm volatile("" : "+m"(y) : : "memory");
    return y + 6;
}

int main(void)
{
    ZASSERT(foo(666) == 666 + 5 + 6);
    return 0;
}

