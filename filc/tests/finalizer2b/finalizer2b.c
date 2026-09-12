#include <stdfil.h>
#include <inttypes.h>

static zgc_finq* finq;
static zweak* weak;
static uintptr_t p_val;

static __attribute__((noinline)) void do_stuff(unsigned count)
{
    int* p = zgc_finq_alloc(finq, sizeof(int));
    weak = zweak_new(p);
    ZASSERT(zweak_get(weak) == p);
    *p = count;
    p_val = (uintptr_t)p;
    ZASSERT(zweak_get(weak) == p);
}

int main()
{
    finq = zgc_finq_new();
    unsigned count;
    for (count = 10000; count--;) {
        do_stuff(count);
        zgc_request_and_wait();
        ZASSERT(!zweak_get(weak));
        int* p = zgc_finq_wait(finq);
        ZASSERT((uintptr_t)p == p_val);
        ZASSERT(*p == count);
        ZASSERT(!zweak_get(weak));
    }
    return 0;
}

