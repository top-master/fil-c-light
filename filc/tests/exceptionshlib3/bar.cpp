#include "header.h"

void foo();

__attribute__((visibility("default"))) void bar()
{
    try {
        foo();
    } catch (const MyException&) {
    }
}

