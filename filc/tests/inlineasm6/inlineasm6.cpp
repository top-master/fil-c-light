#include <stdfil.h>

__attribute__((__noinline__)) void foo(int& x)
{
    asm volatile("" : "+r,m"(x) : : "memory");
}

int main()
{
    int x = 666;
    foo(x);
    ZASSERT(x == 666);
    return 0;
}

