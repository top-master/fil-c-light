#include <stdfil.h>

int main(void)
{
    /* Multi-alternative constraints: the C source spells them "r,r", which
       clang normalizes to "r|r" in the LLVM IR constraint string. The safe
       inline asm validator does not support alternatives. */
    unsigned long x = 1;
    unsigned long y = 2;
    asm volatile("add %0, %1, %2" : "=r,r"(x) : "r,r"(y), "r,r"(x));
    zprintf("not reached\n");
    return 0;
}
