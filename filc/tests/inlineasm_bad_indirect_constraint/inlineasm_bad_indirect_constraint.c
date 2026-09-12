#include <stdfil.h>

int main(void)
{
    int x = 42;
    int y = 0;
    asm("movl %1, %0" : "=r"(y) : "*r"(x));
    zprintf("y = %d\n", y);
    return 0;
}
