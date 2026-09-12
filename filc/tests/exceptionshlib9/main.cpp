#include "header.h"
#include <stdlib.h>
#include <dlfcn.h>

int main()
{
    void* lib = dlopen("filc/test-output/exceptionshlib9/libbar.so", RTLD_LAZY | RTLD_LOCAL);
    void (*bar)() = (void(*)())dlsym(lib, "bar");
    bar();
    return 0;
}

