#include <stdfil.h>

struct Foo {
    int x;
    int y;
    int z;
    int w;
};

__attribute__((__noinline__)) void foo(Foo& x)
{
    asm volatile("" : "+r,m"(x) : : "memory");
}

int main()
{
    Foo x;
    x.x = 1;
    x.y = 2;
    x.z = 3;
    x.w = 4;
    foo(x);
    ZASSERT(x.x == 1);
    ZASSERT(x.y == 2);
    ZASSERT(x.z == 3);
    ZASSERT(x.w == 4);
    return 0;
}

