#include <stdfil.h>

extern int x;

struct Foo
{
    Foo()
    {
        zprintf("foo!\n");
        x = 666;
    }
};

inline Foo foo;
