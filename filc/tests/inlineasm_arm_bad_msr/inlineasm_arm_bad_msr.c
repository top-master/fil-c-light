#include <stdfil.h>

int main(void)
{
    unsigned long x = 0;
    asm volatile("msr nzcv, %0"
                 :
                 : "r"(x));
    zprintf("not reached\n");
    return 0;
}
