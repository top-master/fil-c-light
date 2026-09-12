#include <stdfil.h>
#include <inttypes.h>

static zgc_finq* finq;
static zweak* weak;
static zweak_map* weak_map;
static uintptr_t p_val;

static __attribute__((noinline)) void do_stuff(void)
{
    int* p = zgc_finq_alloc(finq, sizeof(int));
    int* q = zgc_alloc(sizeof(int));
    weak = zweak_new(p);
    ZASSERT(zweak_get(weak) == p);
    zweak_map_set(weak_map, p, q);
    ZASSERT(zweak_map_get(weak_map, p) == q);
    zprintf("(do_stuff) p = %P\n", p);
    *p = 1410;
    *q = 666;
    p_val = (uintptr_t)p;
    ZASSERT(zweak_get(weak) == p);
    ZASSERT(zweak_map_get(weak_map, p) == q);
}

int main()
{
    finq = zgc_finq_new();
    weak_map = zweak_map_new();
    do_stuff();
    zgc_request_and_wait();
    ZASSERT(!zweak_get(weak));
    int* p = zgc_finq_wait(finq);
    ZASSERT(!zweak_map_get(weak_map, p));
    zprintf("(main) p = %P\n", p);
    ZASSERT((uintptr_t)p == p_val);
    ZASSERT(*p == 1410);
    ZASSERT(!zweak_get(weak));
    ZASSERT(!zweak_map_get(weak_map, p));
    return 0;
}

