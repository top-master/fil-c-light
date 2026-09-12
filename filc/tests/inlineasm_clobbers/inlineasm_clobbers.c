#include <stdfil.h>

int main(void)
{
    int x = 42;
    int y = 0;
    asm volatile("movl %1, %0"
                 : "=r"(y)
                 : "r"(x)
                 : "memory", "dirflag", "fpsr", "flags");
    ZASSERT(y == 42);
    return 0;
}
