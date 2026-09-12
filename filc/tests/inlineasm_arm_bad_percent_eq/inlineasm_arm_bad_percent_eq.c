#include <stdfil.h>

int main(void)
{
    /* %= expands to the unique-id placeholder, which shows up in the asm
       string as "${:uid}" - not supported by the safe inline asm
       validator. */
    unsigned long x = 1;
    unsigned long y = 2;
    asm volatile("nop\n\tadd %0, %1, %0\n\t%=" : "+r"(x) : "r"(y));
    zprintf("not reached\n");
    return 0;
}
