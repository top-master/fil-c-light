#include <stdfil.h>
#include <filc_test_support.h>
#include <stdlib.h>

static __attribute__((noinline)) void foo1(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(4)) == 32);
}

static __attribute__((noinline)) void foo2(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(16)) == 32);
}

static __attribute__((noinline)) void foo3(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(20)) == 48);
}

static __attribute__((noinline)) void foo4(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(32)) == 48);
}

static __attribute__((noinline)) void foo5(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(36)) == 64);
}

static __attribute__((noinline)) void foo6(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(65536)) == 74240);
}

static __attribute__((noinline)) void foo7(void)
{
    ZASSERT(zgc_get_allocation_size(malloc(262144)) == 520192);
}

int main()
{
    foo1();
    foo2();
    foo3();
    foo4();
    foo5();
    if (zgc_page_size() == 4096) {
        foo6();
        foo7();
    } /* else our constants are wrong; FIXME: maybe add variants of this test for different page
         sizes */
    return 0;
}

