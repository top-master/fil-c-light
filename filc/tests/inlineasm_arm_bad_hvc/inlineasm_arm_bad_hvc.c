#include <stdfil.h>

int main(void)
{
    /* HVC is a hypervisor call: it traps to the kernel. */
    asm volatile("hvc #0");
    zprintf("not reached\n");
    return 0;
}
