#include <stdfil.h>

void foo()
{
    zprintf("in foo");
}

int bar = 666;
__thread int baz = 42;
