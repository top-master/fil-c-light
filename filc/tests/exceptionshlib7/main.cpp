#include "header.h"
#include <stdlib.h>
#include <dlfcn.h>

int main()
{
    void* lib = dlopen("filc/test-output/exceptionshlib7/libfoo.so", RTLD_LAZY | RTLD_GLOBAL);
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

