#include "struct.h"
#include <stdfil.h>

void bar(struct foo foo);

int main()
{
    struct foo foo;
    foo.x = 1;
    foo.y = 2;
    foo.z = 3;
    foo.w = 4;
    bar(foo);
    ZASSERT(foo.x == 1);
    ZASSERT(foo.y == 2);
    ZASSERT(foo.z == 3);
    ZASSERT(foo.w == 4);
    return 0;
}

