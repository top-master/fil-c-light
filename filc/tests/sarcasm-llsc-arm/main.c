/* ldxr/stxr (ARMv8.0 baseline LL/SC) through sarcasm: N threads each perform
   M LL/SC-loop increments on ONE long cell (and M byte-increments on a byte
   cell). If an RMW is ever lost the final count comes up short. Also the
   ldaxr/stlxr acquire/release forms and an LL/SC-built compare-exchange,
   single-threaded with exact old-value checks. Runs under allocation churn
   so FUGC marking/scanning happens while the LL/SC loops execute. */
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

void llsc_inc(long* cell);
void llsc_inc_b(unsigned char* cell);
long llsc_add_acq(long* cell, long delta);
long llsc_cas(long* cell, long expected, long desired);

#define N 4
#define M 20000
#define MB 100

static long* cell;
static unsigned char* bcell;

static void* worker(void* arg)
{
    size_t i;
    for (i = 0; i < M; i++) {
        llsc_inc(cell);
        if (i < MB)
            llsc_inc_b(bcell);
        /* churn so the GC keeps marking/scanning while LL/SC loops run */
        void* p = malloc(64);
        memset(p, 1, 64);
        free(p);
    }
    return NULL;
}

int main()
{
    cell = malloc(sizeof(long));
    bcell = malloc(16);
    ASSERT(cell && bcell);
    *cell = 0;
    *bcell = 0;

    /* single-threaded sanity: the ldaxr/stlxr add form, old-value return */
    long old = llsc_add_acq(cell, 5);
    ASSERT(old == 0);
    ASSERT(*cell == 5);
    old = llsc_add_acq(cell, -2);
    ASSERT(old == 5);
    ASSERT(*cell == 3);
    /* the LL/SC compare-exchange: match and mismatch */
    ASSERT(llsc_cas(cell, 3, 100) == 1);
    ASSERT(*cell == 100);
    ASSERT(llsc_cas(cell, 3, 200) == 0);
    ASSERT(*cell == 100);
    *cell = 0;

    pthread_t th[N];
    size_t i;
    for (i = 0; i < N; i++)
        ASSERT(!pthread_create(&th[i], NULL, worker, NULL));
    for (i = 0; i < N; i++)
        ASSERT(!pthread_join(th[i], NULL));

    /* every increment landed exactly once */
    ASSERT(*cell == (long)N * M);
    ASSERT(*bcell == (unsigned char)(N * MB));
    printf("llsc arm ok\n");
    return 0;
}
