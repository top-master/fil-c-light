/* FP/SIMD state preservation across the Phase-2 injected runtime calls: an
   xmm value (a double converted from a long) is kept live across the atomic
   pointer store / compare-exchange / locked-atomic-RMW calls — all of which
   can allocate and therefore clobber caller-saved xmm registers. sarcasm must
   save/restore the live vector state around them (fpSave/fpRestore). The
   round-tripped long must come back exactly; the pointer operations are
   checked too. */
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

long fp_ap_store(void** pair, long v);
long fp_ap_cas(void** triple, void* expected);
long fp_alsp_lock_add(void** slot, long delta);

int main()
{
    char* buf = malloc(64);
    size_t i;
    ASSERT(buf);
    for (i = 0; i < 64; i++)
        buf[i] = (char)(i + 1);
    void** pair = malloc(2 * sizeof(void*));
    void** triple = malloc(3 * sizeof(void*));
    void** slot = malloc(sizeof(void*));
    ASSERT(pair && triple && slot);

    size_t repeat = 30000;
    if (zgc_is_stw())
        repeat = 1000;
    long magic = 1234567890123L;    /* exactly representable as a double */
    for (i = 0; i < repeat; i++) {
        /* churn so the runtime calls hit allocation/marking paths that use
           vector code internally */
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);

        pair[0] = &buf[0];
        pair[1] = &buf[(i * 5) & 63];
        ASSERT(fp_ap_store(pair, magic + (long)(i & 1023)) == magic + (long)(i & 1023));
        ASSERT(pair[0] == &buf[(i * 5) & 63]);

        triple[0] = &buf[0];
        triple[1] = &buf[(i * 3) & 63];
        triple[2] = (void*)(magic + (long)(i & 1023));   /* the long, as an integer word */
        ASSERT(fp_ap_cas(triple, &buf[0]) == magic + (long)(i & 1023));
        ASSERT(triple[0] == &buf[(i * 3) & 63]);

        /* the lock-add converts delta into the live xmm value and returns its
           round-trip; the slot walks forward by delta (compared as an
           integer — no dereference of the far-out pointer) */
        *slot = &buf[0];
        long d = magic + (long)(i & 1023);
        ASSERT(fp_alsp_lock_add(slot, d) == d);
        ASSERT(*(uintptr_t*)slot == (uintptr_t)&buf[0] + (uintptr_t)d);
    }
    printf("aptr fp att ok\n");
    return 0;
}
