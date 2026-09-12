#include <stdfil.h>

int main(void)
{
    asm volatile("b 1f\n\t"
                 "1:\n\t"
                 "nop");
    zprintf("not reached\n");
    return 0;
}
