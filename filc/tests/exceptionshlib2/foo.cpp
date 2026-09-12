#include "header.h"

__attribute__((visibility("default"))) void foo()
{
    throw MyException();
}

