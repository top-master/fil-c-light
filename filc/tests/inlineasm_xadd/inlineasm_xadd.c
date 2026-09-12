#include <stdfil.h>

int main(void)
{
    /* XADD dest, src: dest = dest + src; src = old dest. AT&T: xadd src, dest.
       Both operands are read-modify-write; arithmetic flags are set. */
    unsigned long a = 10, b = 20;
    asm volatile("xadd %1, %0" : "+r"(a), "+r"(b) :: "cc");
    ZASSERT(a == 30);
    ZASSERT(b == 10);
    return 0;
}
