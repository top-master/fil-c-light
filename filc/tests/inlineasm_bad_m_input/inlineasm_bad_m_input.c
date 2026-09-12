#include <stdfil.h>

int main(void)
{
    int x = 42;
    int y;
    asm("movl %0, %1" : "=r"(y) : "m"(x));
    zprintf("y = %d\n", y);
    return 0;
}
