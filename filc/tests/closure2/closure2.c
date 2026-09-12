#include <stdfil.h>
#include <stdlib.h>

static void foo(void)
{
    ZASSERT(!zcallee_closure_data());
}

int main()
{
    void (*foo_closure)(void) = zclosure_new(foo, NULL);
    foo_closure();
    return 0;
}

