#include <stdfil.h>

int main(void)
{
    unsigned long a = 10;
    unsigned long b = 20;
    unsigned long c = 0;
    asm volatile(
        "movq %1, %0\n\t"
        "addq %2, %0"
        : "=a"(c)
        : "S"(a), "D"(b)
        : "cc");
    ZASSERT(c == 30);
    return 0;
}
