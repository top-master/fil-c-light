#include <stdfil.h>

int main(void)
{
    unsigned x = 666;
    unsigned y = 666;
    
    asm volatile("add %0, %1" : "+r"(x) : "r"(y) : "cc");

    ZASSERT(x == 666 * 2);

    return 0;
}
