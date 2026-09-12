/* `;! load store ptr`: NON-atomic read-modify-write on a pointer slot (load,
   op on the intval, store — the capability rides through). Value + capability
   checks (every result dereferenced), and native flag behavior for a jcc/setcc
   immediately after the annotated instruction. */
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

void* lsp_add(void** slot, long delta);
void* lsp_sub(void** slot, long delta);
void* lsp_inc(void** slot);
void* lsp_dec(void** slot);
long lsp_xor(void** slot, long v);
long lsp_add_cf(void** slot, long delta);
long lsp_add_jc(void** slot, long delta);
void* lsp_or(void** slot, long v);
void* lsp_and(void** slot, long v);
void* lsp_neg(void** slot);
void* lsp_not(void** slot);
int lsp_deref(void** slot);

int main()
{
    char* buf = malloc(64);
    size_t i;
    ASSERT(buf);
    for (i = 0; i < 64; i++)
        buf[i] = (char)(i + 1);
    void** slot = malloc(sizeof(void*));
    ASSERT(slot);

    /* walk forward through the buffer, dereferencing every hop */
    *slot = &buf[0];
    char* p = lsp_add(slot, 5);
    ASSERT(p == &buf[5]);
    ASSERT(*p == 6);
    p = lsp_add(slot, 8);
    ASSERT(p == &buf[13]);
    ASSERT(*p == 14);
    /* and backward */
    p = lsp_sub(slot, 3);
    ASSERT(p == &buf[10]);
    ASSERT(*p == 11);
    /* unary forms */
    p = lsp_inc(slot);
    ASSERT(p == &buf[11]);
    p = lsp_dec(slot);
    ASSERT(p == &buf[10]);
    ASSERT(*p == 11);

    /* ZF consumer immediately after the annotated RMW: xor with the current
       intval gives 0 (ZF=1); xor again restores the pointer (ZF=0). */
    uintptr_t saved = *(uintptr_t*)slot;        /* current intval, as an integer */
    ASSERT(saved == (uintptr_t)&buf[10]);
    ASSERT(lsp_xor(slot, (long)saved) == 1);    /* iv ^ iv == 0 -> ZF set */
    ASSERT(*(uintptr_t*)slot == 0);             /* intval destroyed... */
    ASSERT(lsp_xor(slot, (long)saved) == 0);    /* 0 ^ saved != 0 -> ZF clear */
    ASSERT(*(uintptr_t*)slot == saved);         /* ...but fully restored */
    ASSERT(lsp_deref(slot) == 11);              /* capability survived all of it */

    /* CF consumer immediately after: adding the negated intval wraps to 0 */
    saved = *(uintptr_t*)slot;
    ASSERT(lsp_add_cf(slot, -(long)saved) == 1);    /* iv + (-iv) == 0 -> CF set */
    ASSERT(*(uintptr_t*)slot == 0);
    ASSERT(lsp_add_cf(slot, (long)saved) == 0);     /* 0 + saved: no carry */
    ASSERT(*(uintptr_t*)slot == saved);
    ASSERT(lsp_deref(slot) == 11);

    /* same via a branch (jc) consumer */
    saved = *(uintptr_t*)slot;
    ASSERT(lsp_add_jc(slot, -(long)saved) == 1);    /* wraps to 0: carry */
    ASSERT(lsp_add_jc(slot, (long)saved) == 0);     /* no carry */
    ASSERT(*(uintptr_t*)slot == saved);
    ASSERT(lsp_deref(slot) == 11);

    /* or/and on the intval, capability still preserved */
    saved = *(uintptr_t*)slot;
    p = lsp_or(slot, 1);                        /* set the low bit of the address */
    ASSERT((uintptr_t)p == (saved | 1));
    p = lsp_and(slot, -2);                      /* clear it again */
    ASSERT(p == (char*)saved);
    ASSERT(lsp_deref(slot) == 11);

    /* neg/not round-trips: iv = -iv then -iv again, iv = ~iv then ~iv again;
       the capability rides through both */
    saved = *(uintptr_t*)slot;
    p = lsp_neg(slot);
    ASSERT((uintptr_t)p == (uintptr_t)(- (intptr_t)saved));
    p = lsp_neg(slot);
    ASSERT(p == (char*)saved);
    ASSERT(lsp_deref(slot) == 11);
    p = lsp_not(slot);
    ASSERT((uintptr_t)p == ~saved);
    p = lsp_not(slot);
    ASSERT(p == (char*)saved);
    ASSERT(lsp_deref(slot) == 11);

    /* GC churn: the RMW's internal load roots the lower across the store
       sequence's safepoints (ensure-aux / barrier) */
    size_t repeat = 50000;
    if (zgc_is_stw())
        repeat = 1000;
    *slot = &buf[0];
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        p = lsp_add(slot, 1);
        if ((uintptr_t)p == (uintptr_t)&buf[63])
            p = lsp_sub(slot, 63);
        ASSERT(*p == (char)((p - buf) + 1));
    }
    printf("aptr rmw int ok\n");
    return 0;
}
