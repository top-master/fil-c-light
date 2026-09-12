#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long expected = 1;
    unsigned long newv = 2;
    asm volatile("cmpxchg %2, %1"
                 : "=a"(expected), "+r"(x)
                 : "0"(expected), "r"(newv));
    return 0;
}
