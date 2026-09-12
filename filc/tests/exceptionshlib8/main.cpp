#include "header.h"
#include <stdlib.h>
#include <dlfcn.h>

int main()
{
    void* lib = dlopen("filc/test-output/exceptionshlib8/libbar.so", RTLD_LAZY | RTLD_GLOBAL);
    void (*bar)() = (void(*)())dlsym(lib, "bar");
    bar();
    return 0;
}

