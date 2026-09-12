#include <stdfil.h>

static zweak* w;
static unsigned long addr_bits;

static int (*resolve_foo(void))(void) {
    void* p = zgc_alloc(32);
    *(int*)p = 0x1234;
    w = zweak_new(p);
    return (int (*)(void))p;
}

int foo(void) __attribute__((ifunc("resolve_foo")));

static __attribute__((noinline)) void trigger(void) {
    addr_bits = (unsigned long)(void*)foo;
}

int main(void) {
    trigger();
    ZASSERT(addr_bits);

    zgc_request_and_wait();

    ZASSERT(zweak_get(w));
    return 0;
}


