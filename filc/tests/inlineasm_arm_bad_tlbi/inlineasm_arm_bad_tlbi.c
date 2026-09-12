#include <stdfil.h>

int main(void)
{
    /* TLBI VAAE1IS, x0 invalidates TLB entries: a system operation. */
    asm volatile("tlbi vaae1is, x0");
    zprintf("not reached\n");
    return 0;
}
