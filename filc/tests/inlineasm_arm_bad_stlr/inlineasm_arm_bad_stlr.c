#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    /* STLR is a store-release to memory. */
    asm volatile("stlr %x0, [%1]"
                 :
                 : "r"(x), "r"(y)
                 : "memory");
    zprintf("not reached %lu %lu\n", x, y);
    return 0;
}
