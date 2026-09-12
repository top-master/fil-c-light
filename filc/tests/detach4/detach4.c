#include <pthread.h>
#include <stdfil.h>
#include <stdlib.h>
#include <unistd.h>

static void* thread_main(void* arg)
{
    ZASSERT(!arg);
    return NULL;
}

int main()
{
    unsigned i, j;
    for (i = 100; i--;) {
        for (j = 10; j--;) {
            pthread_attr_t attr;
            pthread_attr_init(&attr);
            pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
            pthread_t t;
            pthread_create(&t, &attr, thread_main, NULL);
        }
        usleep(1000);
    }
    return 0;
}

