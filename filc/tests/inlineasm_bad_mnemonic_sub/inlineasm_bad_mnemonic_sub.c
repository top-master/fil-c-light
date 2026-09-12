#include <stdfil.h>

int main(void)
{
    int x = 5;
    asm("subl $1, %0" : "+r"(x));
    zprintf("x = %d\n", x);
    return 0;
}
