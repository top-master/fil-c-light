#include <stdfil.h>

int main(void)
{
    int x = 1;
    asm("shll $1, %0" : "+r"(x));
    zprintf("x = %d\n", x);
    return 0;
}
