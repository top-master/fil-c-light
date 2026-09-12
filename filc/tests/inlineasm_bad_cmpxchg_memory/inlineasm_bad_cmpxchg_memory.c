#include <stdfil.h>

int main(void)
{
    unsigned long expected = 0;
    unsigned long newv = 1;
    unsigned long p = 0;
    asm volatile("cmpxchg %2, (%3)"
                 : "=a"(expected)
                 : "0"(expected), "r"(newv), "r"(p)
                 : "cc");
    return 0;
}
