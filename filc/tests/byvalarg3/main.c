#include "union.h"
#include <stdfil.h>
#include <string.h>

void bar(union foo foo);

int main()
{
    union foo foo;
    foo.x = 1;
    foo.q = "hello";
    foo.z = 3;
    foo.s = "world";
    bar(foo);
    ZASSERT(foo.x == 1);
    ZASSERT(!strcmp(foo.q, "hello"));
    ZASSERT(foo.z == 3);
    ZASSERT(!strcmp(foo.s, "world"));
    return 0;
}

