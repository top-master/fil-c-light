#include <stdfil.h>

int main(void)
{
    asm volatile("1:\n\t"
                 "nop");
    zprintf("not reached\n");
    return 0;
}
