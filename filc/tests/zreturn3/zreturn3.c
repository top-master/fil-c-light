#include <stdfil.h>
#include "utils.h"
#include <string.h>

static char* bar(char* a, int b)
{
    return zasprintf("%s %d", a, b);
}

static void foo()
{
    zreturn(zcall(bar, zargs()));
}

int main()
{
    char* (*f)(char*, int) = opaque(foo);
    ZASSERT(!strcmp(f("hello", 666), "hello 666"));
    return 0;
}

