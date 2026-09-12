#include <stdfil.h>

int main(void)
{
    int result = 0;
    int a = 10;
    int b = 5;
    asm("movl %1, %0; addl %2, %0"
        : "=r"(result)
        : "r"(a), "r"(b)
        : "cc");
    ZASSERT(result == 15);
    return 0;
}
