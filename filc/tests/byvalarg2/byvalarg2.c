#include "struct.h"

char foo(struct foo x, struct foo y)
{
    return x.a + y.a;
}
