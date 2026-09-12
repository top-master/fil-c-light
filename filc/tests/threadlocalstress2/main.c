#include <pthread.h>
#include <stdfil.h>
#include "utils.h"
#include <stdlib.h>
#include "header.h"

#define NTHREADS 10
#define REPEAT 1000

static void* thread_main(void *arg)
{
    ZASSERT(*ptr == 666);
    int value = (int)arg;
    ZASSERT(value);
    ptr = malloc(sizeof(int));
    *ptr = value;
    ZASSERT(*(int*)opaque(ptr2) == value);
    ZASSERT(ptr2 == ptr);
    return NULL;
}

int main()
{
    pthread_t threads[NTHREADS];
    unsigned index;
    unsigned count;
    for (count = REPEAT; count--;) {
        for (index = NTHREADS; index--;)
            ZASSERT(!pthread_create(threads + index, NULL, thread_main, (void*)(1 + count + index)));
        for (index = NTHREADS; index--;)
            ZASSERT(!pthread_join(threads[index], NULL));
    }
    return 0;
}

