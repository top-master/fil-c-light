/* Multithreaded stress for the locked `;! atomic load store ptr` compare-
   exchange loop: N threads each perform M locked atomic RMWs (+8) on ONE
   pointer slot (then M locked -8s on a second slot). If a RMW is ever lost,
   the final intval comes up short. Final values are compared as integers
   (the slot walks within a big-enough buffer), and the final pointer is
   dereferenced to prove the capability rode through every hop. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
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

void ap_lock_add8(void** slot);
void ap_lock_dec8(void** slot);
void* ap_load(void** slot);

#define N 4
#define M 10000

static void** slot;
static void** slot2;
static char* buf;
static char* buf2;

static void* worker(void* arg)
{
    size_t i;
    for (i = 0; i < M; i++) {
        ap_lock_add8(slot);
        ap_lock_dec8(slot2);
        /* churn so the GC keeps marking/scanning while CAS loops run */
        void* p = malloc(64);
        memset(p, 1, 64);
        free(p);
    }
    return NULL;
}

int main()
{
    size_t total = (size_t)N * M;
    buf = malloc(total * 8 + 64);
    buf2 = malloc(total * 8 + 64);
    ASSERT(buf && buf2);
    memset(buf, 7, total * 8 + 64);
    memset(buf2, 7, total * 8 + 64);
    slot = malloc(sizeof(void*));
    slot2 = malloc(sizeof(void*));
    ASSERT(slot && slot2);
    *slot = buf;
    *slot2 = buf2 + total * 8;      /* walks downward */

    pthread_t th[N];
    size_t i;
    for (i = 0; i < N; i++)
        ASSERT(!pthread_create(&th[i], NULL, worker, NULL));
    for (i = 0; i < N; i++)
        ASSERT(!pthread_join(th[i], NULL));

    /* every +8 RMW landed exactly once */
    uintptr_t final_iv = *(uintptr_t*)slot;
    ASSERT(final_iv == (uintptr_t)buf + total * 8);
    uintptr_t final_iv2 = *(uintptr_t*)slot2;
    ASSERT(final_iv2 == (uintptr_t)buf2);
    /* and the capability is intact: the loaded pointer dereferences */
    char* p = ap_load(slot);
    ASSERT(p == buf + total * 8);
    ASSERT(*p == 7);                    /* slack byte past the walk region */
    p = ap_load(slot2);
    ASSERT(p == buf2);
    ASSERT(*p == 7);
    printf("aptr stress att ok\n");
    return 0;
}
