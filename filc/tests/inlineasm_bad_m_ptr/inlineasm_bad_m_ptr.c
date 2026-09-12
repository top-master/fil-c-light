#include <stdfil.h>

int main(void)
{
    int x = 42;
    int y;
    int *p = &x;
    asm("movl %0, %1" : "=r"(y) : "m"(p));
    zprintf("y = %d\n", y);
    return 0;
}
