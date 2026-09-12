#include <stdfil.h>
#include <inttypes.h>

static zgc_finq* finq;
static zweak* weak;
static zweak_map* weak_map;
static uintptr_t p_val;

static __attribute__((noinline)) void do_stuff(unsigned count)
{
    int* p = zgc_finq_alloc(finq, sizeof(int));
    int* q = zgc_alloc(sizeof(int));
    weak = zweak_new(p);
    ZASSERT(zweak_get(weak) == p);
    zweak_map_set(weak_map, p, q);
    *p = count;
    *q = count * 666;
    p_val = (uintptr_t)p;
    ZASSERT(zweak_get(weak) == p);
    ZASSERT(zweak_map_get(weak_map, p) == q);
    ZASSERT(*p == count);
    ZASSERT(*q == count * 666);
}

int main()
{
    finq = zgc_finq_new();
    weak_map = zweak_map_new();
    unsigned count;
    for (count = 10000; count--;) {
        do_stuff(count);
        zgc_request_and_wait();
        ZASSERT(!zweak_get(weak));
        int* p = zgc_finq_wait(finq);
        ZASSERT(!zweak_map_get(weak_map, p));
        ZASSERT((uintptr_t)p == p_val);
        ZASSERT(*p == count);
        ZASSERT(!zweak_get(weak));
        ZASSERT(!zweak_map_get(weak_map, p));
    }
    return 0;
}

