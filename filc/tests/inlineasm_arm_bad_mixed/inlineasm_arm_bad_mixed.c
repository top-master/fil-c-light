#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    unsigned long z = 3;
    /* first instruction is fine, second one is not */
    asm volatile("add %0, %1, %2\n\t"
                 "ldr %0, [%1]"
                 : "=&r"(x)
                 : "r"(y), "r"(z));
    zprintf("not reached %lu\n", x);
    return 0;
}
