#include "header.h"
#include <stdlib.h>
#include <dlfcn.h>

int main()
{
    void* lib = dlopen("filc/test-output/exceptionshlib10/libbar.so", RTLD_LAZY | RTLD_LOCAL);
    void (*bar)(void (*)()) = (void(*)(void (*)()))dlsym(lib, "bar");
    lib = dlopen("filc/test-output/exceptionshlib10/libfoo.so", RTLD_LAZY | RTLD_LOCAL);
    void (*foo)() = (void(*)())dlsym(lib, "foo");
    bar(foo);
    return 0;
}

