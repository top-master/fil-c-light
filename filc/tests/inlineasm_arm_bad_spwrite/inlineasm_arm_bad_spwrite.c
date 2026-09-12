#include <stdfil.h>

int main(void)
{
    unsigned long x = 0;
    asm volatile("mov sp, %0"
                 :
                 : "r"(x));
    zprintf("not reached\n");
    return 0;
}
