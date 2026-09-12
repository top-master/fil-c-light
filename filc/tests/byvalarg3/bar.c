#include "union.h"
#include <stdfil.h>
#include <string.h>

void baz(union foo* foo);

void bar(union foo foo)
{
    ZASSERT(foo.x == 1);
    ZASSERT(!strcmp(foo.q, "hello"));
    ZASSERT(foo.z == 3);
    ZASSERT(!strcmp(foo.s, "world"));
    baz(&foo);
    ZASSERT(!strcmp(foo.p, "witaj"));
    ZASSERT(foo.y == 667);
    ZASSERT(!strcmp(foo.r, "bywaj"));
    ZASSERT(foo.w == 669);
}

