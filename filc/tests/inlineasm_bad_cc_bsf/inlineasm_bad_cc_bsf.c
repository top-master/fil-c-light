#include <stdfil.h>

int main(void)
{
    int x = 0;
    int y = 0x10;
    asm("bsfl %1, %0" : "=r"(x) : "r"(y));
    zprintf("x = %d\n", x);
    return 0;
}
