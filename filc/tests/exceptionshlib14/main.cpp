#include <stdlib.h>
#include <dlfcn.h>

int main()
{
    void* lib = dlopen("filc/test-output/exceptionshlib14/libbar.so", RTLD_LAZY | RTLD_GLOBAL);
    void (*bar)(void (*)()) = (void(*)(void (*)()))dlsym(lib, "bar");
    lib = dlopen("filc/test-output/exceptionshlib14/libbaz.so", RTLD_LAZY | RTLD_GLOBAL);
    void (*baz)() = (void(*)())dlsym(lib, "baz");
    bar(baz);
    return 0;
}

