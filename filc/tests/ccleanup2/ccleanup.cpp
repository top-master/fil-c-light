#include <stdfil.h>

extern "C" void bar()
{
}

extern "C" void foo();

int main()
{
    foo();
    zprintf("Here\n");
    return 0;
}

