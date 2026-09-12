#include <stdfil.h>

int main(void)
{
    /* A declared x18 clobber is fine: the compiler will not keep anything
       live in x18 across the asm, and the validator only rejects writes to
       registers that no output constraint or clobber covers. */
    unsigned long x = 1;
    asm volatile("add x18, x18, x18" ::: "x18");
    ZASSERT(x == 1);
    zprintf("x18 clobber ok\n");
    return 0;
}
