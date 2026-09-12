#include <stdfil.h>
#include "utils.h"
#include <string.h>

static char* bar(char* a, int b)
{
    return zasprintf("%s %d", a, b);
}

static void foo(void* target)
{
    zreturn(zcall(target, (char*)zargs() + sizeof(void*)));
}

int main()
{
    char* (*f)(void*, char*, int) = opaque(foo);
    ZASSERT(!strcmp(f(bar, "hello", 666), "hello 666"));
    return 0;
}

