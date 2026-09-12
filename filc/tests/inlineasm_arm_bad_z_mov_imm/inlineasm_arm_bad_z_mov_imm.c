#include <stdfil.h>

int main(void)
{
    /* mov z0.b, #1 writes all of z0; a "v0" clobber only accounts for the
       low 128 bits, so this must be rejected. */
    asm volatile("mov z0.b, #1" ::: "v0");
    zprintf("not reached\n");
    return 0;
}
