#include <stdfil.h>

int main(void)
{
    int x = 3;
    int y = 1;
    asm("xorl %1, %0" : "+r"(x) : "r"(y));
    zprintf("x = %d\n", x);
    return 0;
}
