#include <stdfil.h>

int main(void)
{
    int x = 42;
    asm("movl %0, %%eax" :: "r"(x));
    zprintf("x = %d\n", x);
    return 0;
}
