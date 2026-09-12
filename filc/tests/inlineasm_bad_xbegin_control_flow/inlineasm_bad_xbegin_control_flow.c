#include <stdfil.h>

int main(void)
{
    asm volatile("xbegin 1f\n1:");
    return 0;
}
