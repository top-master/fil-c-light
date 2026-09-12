#include <stdfil.h>

int main(void)
{
    unsigned long x = 0; asm volatile("wrgsbase %0" :: "r"(x));
    return 0;
}
