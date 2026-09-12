#include "header.h"
#include <stdlib.h>

extern "C" void bar(void (*baz)())
{
    bool caught = false;
    try {
        baz();
        abort();
    } catch (const MyException&) {
        caught = true;
    }
    if (!caught)
        abort();
}
