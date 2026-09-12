#include <stdfil.h>
#include <inttypes.h>
#include <string.h>

static zgc_finq* finq;
static uintptr_t p_val;

static __attribute__((noinline)) void do_stuff(unsigned count)
{
    char** p = zgc_finq_alloc(finq, sizeof(char*));
    *p = zasprintf("count = %u", count);
    p_val = (uintptr_t)p;
}

int main()
{
    finq = zgc_finq_new();
    unsigned count;
    for (count = 3000; count--;) {
        do_stuff(count);
        zgc_request_and_wait();
        char** p = zgc_finq_wait(finq);
        ZASSERT((uintptr_t)p == p_val);
        ZASSERT(!strcmp(*p, zasprintf("count = %u", count)));
    }
    return 0;
}

