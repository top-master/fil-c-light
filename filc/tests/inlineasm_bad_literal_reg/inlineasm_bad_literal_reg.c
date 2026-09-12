#include <stdfil.h>

int main(void)
{
    int y;
    asm("movl %%eax, %0" : "=r"(y));
    zprintf("y = %d\n", y);
    return 0;
}
