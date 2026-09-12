#include <stdfil.h>
#include <stdlib.h>
#include <inttypes.h>
#include <pthread.h>
#include <string.h>

static zgc_finq* finq;
static const unsigned n = 30000;

static void* finalizer_thread(void* arg)
{
    unsigned i;
    for (i = n; i--;) {
        char** p = zgc_finq_wait(finq);
        ZASSERT(!strcmp(*p, zasprintf("ptr = %p", p)));
    }
    return NULL;
}

static __attribute__((noinline)) void do_stuff(void)
{
    unsigned i;
    for (i = n; i--;) {
        char** p = zgc_finq_alloc(finq, sizeof(char*));
        *p = zasprintf("ptr = %p", p);
    }
}

int main()
{
    finq = zgc_finq_new();

    pthread_t t;
    pthread_create(&t, NULL, finalizer_thread, NULL);

    do_stuff();

    zgc_request_and_wait();

    pthread_join(t, NULL);
    ZASSERT(!zgc_finq_poll(finq));

    return 0;
}

