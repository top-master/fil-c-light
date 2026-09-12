#include <stdfil.h>
#include <stdlib.h>
#include <inttypes.h>

static zgc_finq* finq;
static const unsigned n = 100000;

static __attribute__((noinline)) void do_stuff(void)
{
    unsigned i;
    for (i = n; i--;) {
        uintptr_t* p = zgc_finq_alloc(finq, sizeof(uintptr_t));
        *p = (uintptr_t)p * 666;
    }
}

int main()
{
    finq = zgc_finq_new();

    do_stuff();

    zgc_request_and_wait();

    unsigned count;
    for (count = 0; ; ++count) {
        uintptr_t* p = zgc_finq_poll(finq);
        if (!p)
            break;
        ZASSERT(*p == (uintptr_t)p * 666);
    }

    ZASSERT(count == n);

    return 0;
}

