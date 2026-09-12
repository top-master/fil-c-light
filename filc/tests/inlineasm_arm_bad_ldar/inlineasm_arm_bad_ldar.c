#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    asm volatile("ldar %x0, [%1]"
                 : "=r"(x)
                 : "r"(y));
    zprintf("not reached %lu\n", x);
    return 0;
}
