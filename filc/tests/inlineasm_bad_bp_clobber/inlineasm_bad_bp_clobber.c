#include <stdfil.h>

int main(void)
{
    int x = 42;
    asm("movl %0, %0" : "+r"(x) : : "rbp");
    zprintf("x = %d\n", x);
    return 0;
}
