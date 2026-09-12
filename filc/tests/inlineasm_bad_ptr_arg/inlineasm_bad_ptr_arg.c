#include <stdfil.h>

int main(void)
{
    int x = 0;
    int *p = &x;
    asm("movq %0, %0" : "+r"(p));
    zprintf("x = %d\n", x);
    return 0;
}
