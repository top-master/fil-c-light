#include <stdfil.h>

int main(void)
{
    /* C-style block comments inside the asm string are not stripped by the
       validator (only '@' and '//' comments are), so the trailing junk is
       parsed as part of the last operand. */
    asm volatile("add x0, x1, x2 /* junk */" ::: "x0", "x1", "x2");
    zprintf("not reached\n");
    return 0;
}
