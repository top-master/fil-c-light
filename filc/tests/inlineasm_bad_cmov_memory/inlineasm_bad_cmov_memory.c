#include <stdfil.h>

int main(void)
{
    unsigned long dst = 0;
    unsigned long p = 0;
    asm volatile("cmovne (%1), %0" : "+r"(dst) : "r"(p));
    return 0;
}
