#include <stdfil.h>

int main(void)
{
    int x = 4;
    asm("shrl $1, %0" : "+r"(x));
    zprintf("x = %d\n", x);
    return 0;
}
