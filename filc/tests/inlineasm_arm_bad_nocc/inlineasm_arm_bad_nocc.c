#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    unsigned long z = 3;
    /* sets flags but has no "cc" clobber */
    asm volatile("adds %w0, %w1, %w2"
                 : "=r"(x)
                 : "r"(y), "r"(z));
    zprintf("not reached %lu\n", x);
    return 0;
}
