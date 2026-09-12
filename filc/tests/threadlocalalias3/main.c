#include "header.h"
#include <stdfil.h>

int main()
{
    ZASSERT(x == 666);
    ZASSERT(y == 666);
    y = 42;
    ZASSERT(x == 42);
    ZASSERT(y == 42);
    return 0;
}

