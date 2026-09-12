#include <stdfil.h>

int main(void)
{
    unsigned long x;
    asm volatile("mrs %0, pmcr_el0"
                 : "=r"(x));
    zprintf("not reached %lu\n", x);
    return 0;
}
