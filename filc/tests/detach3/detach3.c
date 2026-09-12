#include <pthread.h>
#include <stdfil.h>
#include <stdlib.h>
#include <unistd.h>

static void* thread_main(void* arg)
{
    pthread_detach(pthread_self());
    ZASSERT(!arg);
    return NULL;
}

int main()
{
    unsigned i, j;
    for (i = 100; i--;) {
        for (j = 10; j--;) {
            pthread_t t;
            pthread_create(&t, NULL, thread_main, NULL);
        }
        usleep(1000);
    }
    return 0;
}

