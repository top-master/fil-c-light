#include <stdfil.h>

extern "C" void bar()
{
    throw 1410;
}

extern "C" void foo();

int main()
{
    try {
        foo();
    } catch (int e) {
        zprintf("e = %d\n", e);
    }
    return 0;
}

