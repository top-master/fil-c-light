/* GC stress for the sarcasm-assembled store-barrier test: storing a pointer into a heap
   slot must execute the Fil-C store barrier so the GC keeps the stored pointer's object
   alive when marking is in progress. Keep a big live slot array per thread and hammer it
   with pointer stores while allocating, so stores race with concurrent marking; then
   verify everything we kept is still intact. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

void store_ptr(void** p, void* v);

#define NSLOTS 1000

static size_t num_threads = 10;
static size_t repeat = 10000000;

static void* worker(void* arg)
{
    size_t tid = (size_t)arg;
    void** slots = malloc(NSLOTS * sizeof(void*));
    ASSERT(slots);
    size_t i, j;
    for (j = 0; j < NSLOTS; j++)
        slots[j] = NULL;
    for (i = 0; i < repeat; i++) {
        j = (i * 37 + tid * 11) % NSLOTS;
        int* obj = malloc(sizeof(int));
        ASSERT(obj);
        *obj = (int)(i ^ (tid << 16));
        store_ptr(&slots[j], obj);        /* barrier must mark obj if we're mid-marking */
        int* back = (int*)slots[j];
        ASSERT(back == obj);
        ASSERT(*back == (int)(i ^ (tid << 16)));
    }
    /* everything still referenced must still be dereferenceable (not freed/collected) */
    unsigned long sum = 0;
    for (j = 0; j < NSLOTS; j++) {
        if (slots[j])
            sum += (unsigned)*(int*)slots[j];
    }
    free(slots);
    return (void*)sum;
}

int main()
{
    if (zgc_is_stw()) {
        num_threads = 2;
        repeat = 500;
    }
    pthread_t th[num_threads];
    size_t i;
    for (i = 0; i < num_threads; i++)
        ASSERT(!pthread_create(&th[i], NULL, worker, (void*)i));
    for (i = 0; i < num_threads; i++)
        ASSERT(!pthread_join(th[i], NULL));
    printf("ok\n");
    return 0;
}
