#include <stdfil.h>

int main(void)
{
    /* writes x5 which is not covered by any output or clobber */
    asm volatile("add x5, x1, x2");
    zprintf("not reached\n");
    return 0;
}
