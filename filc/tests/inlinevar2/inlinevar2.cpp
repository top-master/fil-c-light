#include <stdfil.h>

static int x;;

struct Foo
{
    Foo() {
        zprintf("foo!\n");
        x = 666;
    }
};

inline Foo foo;

int main()
{
    ZASSERT(x == 666);
    return 0;
}

