#include <stdfil.h>

int main(void)
{
    int x = 42;
    int y;
    asm("movl %1, %0" : "=r"(y) : "r"(x) : "xmm0");
    zprintf("y = %d\n", y);
    return 0;
}
