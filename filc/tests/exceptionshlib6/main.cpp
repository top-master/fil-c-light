#include "header.h"
#include <stdlib.h>
#include <dlfcn.h>

int main()
{
    void* lib = dlopen("filc/test-output/exceptionshlib6/libfoo.so", RTLD_LAZY | RTLD_LOCAL);
    void (*foo)() = (void(*)())dlsym(lib, "foo");
    
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

