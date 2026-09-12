#include <stdfil.h>
#include <stdbool.h>

static bool did_resolve_foo = false;

static int my_foo(void)
{
    return 666;
}

static int (*resolve_foo(void))(void)
{
    zprintf("in resolve_foo\n");

    /* Should be possible to allocate a bunch of stuff in a resolver. */
    unsigned count;
    for (count = 1000000; count--;)
        zgc_alloc(32);
    
    did_resolve_foo = true;
    return my_foo;
}

int foo(void) __attribute__((ifunc("resolve_foo")));

static bool did_resolve_bar = false;

static int my_bar(void)
{
    return 1410;
}

static int (*resolve_bar(void))(void)
{
    zprintf("in resolve_bar\n");

    /* Should be possible to wait for a GC in a resolver. */
    zgc_request_and_wait();
    
    did_resolve_bar = true;
    return my_bar;
}

int bar(void) __attribute__((ifunc("resolve_bar")));

static __attribute__((__noinline__)) void phase1()
{
    ZASSERT(foo() == 666);
    ZASSERT(did_resolve_foo);
    ZASSERT(bar() == 1410);
    ZASSERT(did_resolve_bar);
}

static __attribute__((__noinline__)) void phase2()
{
    did_resolve_foo = false;
    did_resolve_bar = false;
    ZASSERT(foo() == 666);
    ZASSERT(bar() == 1410);
    ZASSERT(!did_resolve_foo);
    ZASSERT(!did_resolve_bar);
}

int main()
{
    phase1();
    phase2();
    zprintf("all good\n");
    return 0;
}

