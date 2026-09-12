#include <stdfil.h>

int x;

struct Foo
{
    Foo()
    {
        zprintf("foo!\n");
        x = 42;
    }
};

inline Foo foo;

int main()
{
    ZASSERT(x == 42 || x == 666);
    return 0;
}

