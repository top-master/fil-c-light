#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    /* LDUR is an unscaled load from memory. */
    asm volatile("ldur %w0, [%1, #-8]"
                 : "=r"(x)
                 : "r"(y));
    zprintf("not reached %lu\n", x);
    return 0;
}
