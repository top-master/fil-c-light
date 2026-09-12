#include <stdfil.h>

int main()
{
    asm volatile("" : : : "memory");
    int x = 666;
    asm volatile("" : "+r"(x));
    ZASSERT(x == 666);
    return 0;
}

