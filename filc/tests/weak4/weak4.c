#include <stdfil.h>
#include <stdlib.h>
#include <pthread.h>

static zweak* weak;
static zgc_cycle_number cycle;

static void* thread_main(void* arg)
{
    zgc_wait(cycle);
    ZASSERT(!zweak_get(weak));
    return NULL;
}

int main()
{
    weak = zweak_new(zgc_alloc(1));
    cycle = zgc_request_fresh();
    pthread_t t;
    pthread_create(&t, NULL, thread_main, NULL);
    pthread_join(t, NULL);
    return 0;
}

