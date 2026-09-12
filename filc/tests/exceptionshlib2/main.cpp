#include "header.h"
#include <stdlib.h>

void foo();

__attribute__((visibility("default"))) int main()
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
    return 0;
}

