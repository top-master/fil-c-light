#include <stdfil.h>

int main(void)
{
    /* LSE atomic swap: a memory read-modify-write. */
    asm volatile("swp x1, x2, [x3]");
    zprintf("not reached\n");
    return 0;
}
