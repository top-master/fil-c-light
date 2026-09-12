#include "struct.h"
#include <stdfil.h>

void baz(struct foo* foo);

void bar(struct foo foo)
{
    ZASSERT(foo.x == 1);
    ZASSERT(foo.y == 2);
    ZASSERT(foo.z == 3);
    ZASSERT(foo.w == 4);
    baz(&foo);
    ZASSERT(foo.x == 666);
    ZASSERT(foo.y == 667);
    ZASSERT(foo.z == 668);
    ZASSERT(foo.w == 669);
}

