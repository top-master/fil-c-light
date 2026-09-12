#include <stdfil.h>

int main(void)
{
    int x;
    asm("movl $42, %0" : "=r"(x));
    ZASSERT(x == 42);
    return 0;
}
