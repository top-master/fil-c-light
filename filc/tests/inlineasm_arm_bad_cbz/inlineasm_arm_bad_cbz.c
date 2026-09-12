#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    asm volatile("cbz %0, 1f\n\t"
                 "1:\n\t"
                 "nop"
                 :
                 : "r"(x));
    zprintf("not reached\n");
    return 0;
}
