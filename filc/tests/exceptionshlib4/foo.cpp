#include "header.h"

__attribute__((visibility("default"))) extern "C" void foo()
{
    throw MyException();
}

