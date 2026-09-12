#include <stdfil.h>
#include <stdlib.h>

static void* ptr;
static zweak* weak;

static __attribute__((noinline)) void do_stuff(void)
{
    ptr = zgc_alloc(1);
    weak = zweak_new(ptr);
    ZASSERT(zweak_get(weak) == ptr);
    zgc_wait(zgc_request_fresh());
    ZASSERT(zweak_get(weak) == ptr);
    ptr = NULL;
}

int main()
{
    for (unsigned i = 10000; i--;) {
        do_stuff();
        zgc_wait(zgc_request_fresh());
        ZASSERT(!zweak_get(weak));
    }
    return 0;
}

