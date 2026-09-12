#include <stdfil.h>

int main(void)
{
    /* asm goto is control flow out of the inline assembly, which the safe
       inline asm model does not support, even when it has an output operand.
       It must compile to a filc_error panic instead of ICEing the compiler. */
    unsigned long x = 1;
    unsigned long y = 2;
    asm volatile goto("add %0, %1, %0"
                      : "+r"(x)
                      : "r"(y)
                      :
                      : lab);
    zprintf("not reached %lu\n", x);
    return 0;
lab:
    zprintf("also not reached\n");
    return 0;
}
