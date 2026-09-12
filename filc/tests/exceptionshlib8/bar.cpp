#include "header.h"
#include <stdlib.h>

extern "C" void foo();

extern "C" void bar()
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
