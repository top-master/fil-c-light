#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    /* STUR is an unscaled store to memory. */
    asm volatile("stur %w0, [%1, #-8]"
                 : "=r"(x)
                 : "r"(y));
    zprintf("not reached %lu\n", x);
    return 0;
}
