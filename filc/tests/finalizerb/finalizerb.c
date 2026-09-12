#include <stdfil.h>
#include <inttypes.h>

static zgc_finq* finq;
static zweak* weak;
static uintptr_t p_val;

static __attribute__((noinline)) void do_stuff(void)
{
    int* p = zgc_finq_alloc(finq, sizeof(int));
    weak = zweak_new(p);
    ZASSERT(zweak_get(weak) == p);
    zprintf("(do_stuff) p = %P\n", p);
    *p = 1410;
    p_val = (uintptr_t)p;
    ZASSERT(zweak_get(weak) == p);
}

int main()
{
    finq = zgc_finq_new();
    do_stuff();
    zgc_request_and_wait();
    ZASSERT(!zweak_get(weak));
    int* p = zgc_finq_wait(finq);
    zprintf("(main) p = %P\n", p);
    ZASSERT((uintptr_t)p == p_val);
    ZASSERT(*p == 1410);
    ZASSERT(!zweak_get(weak));
    return 0;
}

