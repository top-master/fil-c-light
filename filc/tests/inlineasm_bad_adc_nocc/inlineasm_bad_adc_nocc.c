#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    asm volatile("adc $1, %0" : "+r"(x));
    return 0;
}
