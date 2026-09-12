#include <stdfil.h>

int main(void)
{
    unsigned long p = 0; asm volatile("xrstor (%0)" :: "r"(p));
    return 0;
}
