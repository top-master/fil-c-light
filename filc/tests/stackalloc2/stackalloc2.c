#include <stdfil.h>
#include <filc_test_support.h>

static __attribute__((noinline)) void foo1(void)
{
    int a;
    ZASSERT(zgc_get_allocation_size(&a) == 32);
}

static __attribute__((noinline)) void foo2(void)
{
    int b[4];
    ZASSERT(zgc_get_allocation_size(b) == 32);
}

static __attribute__((noinline)) void foo3(void)
{
    int c[5];
    ZASSERT(zgc_get_allocation_size(c) == 48);
}

static __attribute__((noinline)) void foo4(void)
{
    int d[8];
    ZASSERT(zgc_get_allocation_size(d) == 48);
}

static __attribute__((noinline)) void foo5(void)
{
    int e[9];
    ZASSERT(zgc_get_allocation_size(e) == 64);
}

static __attribute__((noinline)) void foo6(void)
{
    int e[16384];
    zprintf("size = %zu\n", zgc_get_allocation_size(e));
    ZASSERT(zgc_get_allocation_size(e) == 74240);
}

static __attribute__((noinline)) void foo7(void)
{
    int e[65536];
    zprintf("size = %zu\n", zgc_get_allocation_size(e));
    ZASSERT(zgc_get_allocation_size(e) == 520192); /* Ouch, this is a major pathology of our
                                                      size classes! */
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

