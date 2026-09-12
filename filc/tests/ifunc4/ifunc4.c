#include <stdfil.h>
#include <stdbool.h>

static bool did_resolve_foo = false;
static void* ptr;

static int my_foo(void)
{
    return 666;
}

static int (*resolve_foo(void))(void)
{
    zprintf("in resolve_foo\n");

    did_resolve_foo = true;
    return my_foo;
}

int foo(void) __attribute__((ifunc("resolve_foo")));

static void* ptr = foo;

int main()
{
    int (*f)(void) = ptr;
    ZASSERT(f() == 666);
    ZASSERT(did_resolve_foo);
    ZASSERT(f == my_foo);
    zprintf("all good\n");
    return 0;
}

