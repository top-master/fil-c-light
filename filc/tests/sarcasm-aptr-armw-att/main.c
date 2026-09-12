/* `;! atomic load store ptr`: atomic RMW on a pointer slot. WITHOUT lock:
   atomic load + op + atomic store (each access atomic). WITH lock: the runtime
   compare-exchange loop (a real atomic RMW). Value + capability (every result
   dereferenced) and native flags for an immediate setcc consumer. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdfil.h>
#include <filc_test_support.h>

#define ASSERT(exp) do { \
    if ((exp)) \
        break; \
    fprintf(stderr, "%s:%d: %s: assertion %s failed.\n", \
            __FILE__, __LINE__, __PRETTY_FUNCTION__, #exp); \
    abort(); \
} while (0)

void* alsp_add(void** slot, long delta);
void* alsp_lock_add(void** slot, long delta);
void* alsp_inc(void** slot);
void* alsp_lock_inc(void** slot);
long alsp_xor(void** slot, long v);
long alsp_lock_xor(void** slot, long v);

int main()
{
    char* buf = malloc(64);
    size_t i;
    ASSERT(buf);
    for (i = 0; i < 64; i++)
        buf[i] = (char)(i + 1);
    void** slot = malloc(sizeof(void*));
    ASSERT(slot);

    /* no-lock form: value + capability */
    *slot = &buf[0];
    char* p = alsp_add(slot, 5);
    ASSERT(p == &buf[5]);
    ASSERT(*p == 6);
    p = alsp_add(slot, -2);
    ASSERT(p == &buf[3]);
    ASSERT(*p == 4);
    p = alsp_inc(slot);
    ASSERT(p == &buf[4]);
    ASSERT(*p == 5);

    /* lock form: value + capability */
    p = alsp_lock_add(slot, 7);
    ASSERT(p == &buf[11]);
    ASSERT(*p == 12);
    p = alsp_lock_add(slot, -4);
    ASSERT(p == &buf[7]);
    ASSERT(*p == 8);
    p = alsp_lock_inc(slot);
    ASSERT(p == &buf[8]);
    ASSERT(*p == 9);

    /* flags consumer immediately after, no-lock form: xor with the current
       intval gives 0 (ZF=1); xor again restores (ZF=0). */
    uintptr_t saved = *(uintptr_t*)slot;
    ASSERT(saved == (uintptr_t)&buf[8]);
    ASSERT(alsp_xor(slot, (long)saved) == 1);
    ASSERT(*(uintptr_t*)slot == 0);
    ASSERT(alsp_xor(slot, (long)saved) == 0);
    ASSERT(*(uintptr_t*)slot == saved);
    ASSERT(*(char*)*slot == 9);                        /* capability intact */

    /* same for the lock form */
    saved = *(uintptr_t*)slot;
    ASSERT(alsp_lock_xor(slot, (long)saved) == 1);
    ASSERT(*(uintptr_t*)slot == 0);
    ASSERT(alsp_lock_xor(slot, (long)saved) == 0);
    ASSERT(*(uintptr_t*)slot == saved);
    ASSERT(*(char*)*slot == 9);

    /* boxed-slot CAS loop: the slot is boxed after all these atomic ops, so
       the runtime's 128-bit box CAS path is the one being exercised */
    size_t repeat = 30000;
    if (zgc_is_stw())
        repeat = 1000;
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        p = alsp_lock_add(slot, i & 1);
        ASSERT(*p == (char)((p - buf) + 1));
        if ((uintptr_t)p > (uintptr_t)&buf[62])
            p = alsp_lock_add(slot, -60);
    }
    printf("aptr armw att ok\n");
    return 0;
}
