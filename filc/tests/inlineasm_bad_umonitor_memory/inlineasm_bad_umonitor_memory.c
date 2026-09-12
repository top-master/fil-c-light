#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    unsigned long addr = 0;
    asm volatile("umonitor %0" : : "r"(addr));
    return 0;
}
