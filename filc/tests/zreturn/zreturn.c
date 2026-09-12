#include <stdfil.h>
#include "utils.h"

static void foo(void)
{
    int x = 666;
    zreturn(&x);
}

int main()
{
    int (*f)(void) = opaque(foo);
    ZASSERT(f() == 666);
    return 0;
}

