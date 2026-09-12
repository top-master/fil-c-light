#include "header.h"
#include <stdlib.h>

extern "C" void bar(void (*foo)())
{
    bool caught = false;
    try {
        foo();
        abort();
    } catch (const MyException&) {
        caught = true;
    }
    if (!caught)
        abort();
}
