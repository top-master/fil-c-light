#include <stdfil.h>

int main(void)
{
    /* asm goto is rejected regardless of what the assembly does. Even with
       all registers declared, the indirect branch out of the asm is control
       flow that the validator cannot account for. */
    unsigned long x = 1;
    unsigned long y = 2;
    asm volatile goto("str %0, [%1]" : : "r"(x), "r"(y) : : lab);
    zprintf("not reached\n");
    return 0;
lab:
    zprintf("also not reached\n");
    return 0;
}
