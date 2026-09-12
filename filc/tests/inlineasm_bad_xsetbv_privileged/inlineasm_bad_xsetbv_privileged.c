#include <stdfil.h>

int main(void)
{
    asm volatile("xsetbv");
    return 0;
}
