#include <stdfil.h>

int main(void)
{
    int x = 42;
    float y;
    asm volatile("cvtsi2ss %1, %0" : "=t"(y) : "r"(x));
    zprintf("done\n");
    return 0;
}
