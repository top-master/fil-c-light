#include "header.h"

extern "C" void foo()
{
    throw MyException();
}

