#include <stdlib.h>
#include <stdfil.h>

void bar();

int foo()
{
    int x;
    try {
        x = 1;
        bar();
        x = 4;
        bar();
        x = 2;
        zthread_self_id();
        x = 3;
        return 42;
    } catch (int& e) {
        return e + x;
    }
}

int main()
{
    ZASSERT(foo() == 42);
    return 0;
}

