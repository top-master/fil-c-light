#define _GNU_SOURCE

#include <dlfcn.h>
#include <stdfil.h>
#include <stdlib.h>

asm(".filc_globl bar");

int main()
{
    void* h = dlopen(NULL, RTLD_LAZY);
    zprintf("h = %p\n", h);
    void* f = dlsym(h, "foo");
    zprintf("f = %p\n", f);
    ZASSERT(((int (*)(void))f)() == 666);
    return 0;
}
