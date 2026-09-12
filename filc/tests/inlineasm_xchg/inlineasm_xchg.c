#include <stdfil.h>

int main(void)
{
    /* XCHG dest, src: swaps the two operands. AT&T: xchg src, dest.
       Both operands are read-modify-write; no flags are modified. */
    unsigned long a = 10, b = 20;
    asm volatile("xchg %1, %0" : "+r"(a), "+r"(b));
    ZASSERT(a == 20);
    ZASSERT(b == 10);
    return 0;
}
