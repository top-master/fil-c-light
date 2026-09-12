#include <stdfil.h>

int main(void)
{
    /* asm goto is control flow out of the inline assembly, which the safe
       inline asm model does not support. It must compile to a filc_error
       panic instead of ICEing the compiler. */
    asm volatile goto("nop" : : : : lab);
    zprintf("not reached\n");
    return 0;
lab:
    zprintf("also not reached\n");
    return 0;
}
