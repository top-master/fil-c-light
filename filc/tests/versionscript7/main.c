#include <dlfcn.h>
#include <stdfil.h>

void* opaque(void*);

int main()
{
    void* lib = dlopen("filc/test-output/versionscript7/libtest.so", RTLD_LAZY | RTLD_LOCAL);
    ZASSERT(lib);

    ZASSERT(dlsym(lib, "foo_a"));
    ZASSERT(dlsym(lib, "foo_b"));
    ZASSERT(dlsym(lib, "bar_a"));
    ZASSERT(dlsym(lib, "bar_b"));

    ZASSERT(!dlsym(lib, "baz_a"));
    ZASSERT(!dlsym(lib, "baz_b"));

    return 0;
}

