#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    unsigned long z = 3;
    asm volatile("ldp %0, %1, [%2]"
                 : "=r"(x), "=r"(y)
                 : "r"(z));
    zprintf("not reached %lu\n", x);
    return 0;
}
