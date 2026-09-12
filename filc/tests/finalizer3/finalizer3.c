#include <stdfil.h>
#include <inttypes.h>

static zgc_finq* finq;
static uintptr_t p_val;

static __attribute__((noinline)) void do_stuff(unsigned count)
{
    int* p = zgc_finq_alloc(finq, sizeof(int));
    *p = count;
    p_val = (uintptr_t)p;
}

int main()
{
    unsigned count;
    for (count = 10000; count--;) {
        finq = zgc_finq_new();
        do_stuff(count);
        zgc_request_and_wait();
        int* p = zgc_finq_wait(finq);
        ZASSERT((uintptr_t)p == p_val);
        ZASSERT(*p == count);
    }
    return 0;
}

