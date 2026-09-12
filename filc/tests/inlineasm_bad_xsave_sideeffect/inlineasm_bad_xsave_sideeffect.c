#include <stdfil.h>

int main(void)
{
    unsigned long p = 0;
    asm volatile("xsave (%2)" : : "a"(0u), "d"(0u), "r"(p));
    return 0;
}
