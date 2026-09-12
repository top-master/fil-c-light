/* Atomic pointer load/store round-trip through sarcasm's `;! atomic load ptr` /
   `;! atomic store ptr` (runtime-call based), plus mixing with the plain
   `;! load ptr` / `;! store ptr` forms in both directions (an atomically-stored
   slot is boxed; the plain load path is box-aware, and vice versa). Every loaded
   pointer is dereferenced to prove its capability survived. Includes an
   allocation-churn loop so the box/rooting paths run under FUGC marking. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

void ap_store(void** slot, void* v);
void* ap_load(void** slot);
void p_store(void** slot, void* v);
void* p_load(void** slot);

int main()
{
    char* buf = malloc(64);
    size_t i;
    ASSERT(buf);
    for (i = 0; i < 64; i++)
        buf[i] = (char)(i + 1);
    void** slot = malloc(4 * sizeof(void*));
    ASSERT(slot);

    /* atomic store -> atomic load, with dereference */
    ap_store(&slot[0], &buf[1]);
    char* p = ap_load(&slot[0]);
    ASSERT(p == &buf[1]);
    ASSERT(*p == 2);

    /* plain store -> atomic load (the plain store wrote the aux entry
       directly, unboxed) */
    p_store(&slot[1], &buf[2]);
    p = ap_load(&slot[1]);
    ASSERT(p == &buf[2]);
    ASSERT(*p == 3);

    /* atomic store -> plain load (the atomic store boxed the slot; the plain
       load path is box-aware) */
    ap_store(&slot[2], &buf[3]);
    p = p_load(&slot[2]);
    ASSERT(p == &buf[3]);
    ASSERT(*p == 4);

    /* NULL round-trip, both directions */
    ap_store(&slot[3], NULL);
    ASSERT(ap_load(&slot[3]) == NULL);
    p_store(&slot[3], NULL);
    ASSERT(ap_load(&slot[3]) == NULL);
    ap_store(&slot[3], NULL);
    ASSERT(p_load(&slot[3]) == NULL);

    /* GC stress: churn allocations between the atomic ops so FUGC marking
       runs while boxes and root slots are live. */
    size_t repeat = 100000;
    if (zgc_is_stw())
        repeat = 2000;
    for (i = 0; i < repeat; i++) {
        ap_store(&slot[i & 3], &buf[(i * 7) & 63]);
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        p = ap_load(&slot[i & 3]);
        ASSERT(p == &buf[(i * 7) & 63]);
        ASSERT(*p == (char)(((i * 7) & 63) + 1));
    }
    /* plain loads of boxed slots under churn, then one more dereference */
    for (i = 0; i < 4; i++) {
        p = p_load(&slot[i]);
        ASSERT(p >= buf && p < buf + 64);
        ASSERT(*p == (char)((p - buf) + 1));
    }
    printf("aptr loadstore int ok\n");
    return 0;
}
