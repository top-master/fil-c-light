#include <stdfil.h>

int main(void)
{
    int a = 10;
    int b = 20;
    asm("movl %1, %0" : "=r"(a) : "0"(b));
    ZASSERT(a == 20);
    return 0;
}
