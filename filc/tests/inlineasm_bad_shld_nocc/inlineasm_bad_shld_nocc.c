#include <stdfil.h>

int main(void)
{
    unsigned long x = 1;
    unsigned long y = 2;
    asm volatile("shld $1, %1, %0" : "+r"(x) : "r"(y));
    return 0;
}
