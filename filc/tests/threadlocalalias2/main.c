#include "header.h"
#include <stdfil.h>

int main()
{
    ZASSERT(y == 666);
    ZASSERT(x == 666);
    x = 42;
    ZASSERT(y == 42);
    ZASSERT(x == 42);
    return 0;
}

