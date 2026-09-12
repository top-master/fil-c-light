#include <stdfil.h>
#include <stdlib.h>

static void* ptr;
static zweak* weak;

static __attribute__((noinline)) void do_stuff(void)
{
    ptr = zgc_alloc(1);
    weak = zweak_new(ptr);
    ZASSERT(zweak_get(weak) == ptr);
    zgc_free(ptr);
    ZASSERT(!zweak_get(weak));
    zgc_request_and_wait();
    ZASSERT(!zweak_get(weak));
    ptr = NULL;
}

int main()
{
    for (unsigned i = 10000; i--;) {
        do_stuff();
        zgc_request_and_wait();
        ZASSERT(!zweak_get(weak));
    }
    return 0;
}

