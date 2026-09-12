#include <stdfil.h>

int main(void)
{
    /* SYS #3, c7, c4, #1, x1 is DC ZVA written with the generic SYS syntax:
       a cache maintenance system operation. */
    asm volatile("sys #3, c7, c4, #1, x1");
    zprintf("not reached\n");
    return 0;
}
