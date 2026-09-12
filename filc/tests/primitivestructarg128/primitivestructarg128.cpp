#include <stdfil.h>

struct Foo {
    int a;
    int b;
    int c;
    int d;
};

static __attribute__((noinline)) void foo(Foo foo)
{
    ZASSERT(foo.a == 1);
    ZASSERT(foo.b == 2);
    ZASSERT(foo.c == 3);
    ZASSERT(foo.d == 4);
}

struct Bar {
    int x;
    Foo foo;
};

static __attribute__((noinline)) void bar(Bar* bar)
{
    foo(bar->foo);
}

int main()
{
    Bar bar;
    bar.x = 42;
    bar.foo.a = 1;
    bar.foo.b = 2;
    bar.foo.c = 3;
    bar.foo.d = 4;
    ::bar(&bar);
    return 0;
}

