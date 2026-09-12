#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    asm volatile("negq %0" : "+r"(x));
    return 0;
}
