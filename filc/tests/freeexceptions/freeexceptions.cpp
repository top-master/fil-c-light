#include <stdlib.h>
#include <stdfil.h>

void bar();

int foo(void* p)
{
    int x;
    try {
        x = 1;
        bar();
        x = 4;
        bar();
        x = 2;
        free(p);
        x = 3;
        return 42;
    } catch (int& e) {
        return e + x;
    }
}

int main()
{
    ZASSERT(foo(malloc(1)) == 42);
    return 0;
}

