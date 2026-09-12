#include <stdfil.h>

void foo(void) asm("bar");

void foo(void)
{
    zprintf("in foo\n");
}
