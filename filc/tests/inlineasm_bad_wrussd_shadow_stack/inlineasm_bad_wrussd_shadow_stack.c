#include <stdfil.h>

int main(void)
{
    unsigned long p = 0; asm volatile("wrussd %0, (%1)" :: "r"(1), "r"(p));
    return 0;
}
