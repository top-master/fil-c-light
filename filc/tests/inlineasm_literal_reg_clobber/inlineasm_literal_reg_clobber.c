#include <stdfil.h>

int main(void)
{
    asm("addl %%eax, %%eax" : : : "eax", "cc");
    zprintf("done\n");
    return 0;
}
