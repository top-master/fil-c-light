#include <stdfil.h>

int main(void)
{
    /* PACIASP rewrites lr (x30), which is not covered by any output
       constraint or clobber. */
    asm volatile("paciasp");
    zprintf("not reached\n");
    return 0;
}
