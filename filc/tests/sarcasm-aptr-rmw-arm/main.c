/* `;! atomic load store ptr` on ARM64: an LSE atomic RMW (ldadd/ldaddal/
   swp/swpal/stadd/ldset/ldclr) on a pointer slot. ldadd/stadd/ldset/ldclr
   lower to the runtime compare-exchange loop: the op runs on the intval and
   the capability rides through the slot. swp lowers to
   filc_xchg_ptr_with_manual_tracking — the new value carries the SOURCE's
   capability, so a cross-object exchange (slot's pointer swapped for a
   pointer into a DIFFERENT allocation) stays dereference-able, and an
   integer source is stored with a null capability. The old value comes back
   AS A POINTER (every result dereferenced below). Includes the boxed-slot
   churn path under FUGC marking. */
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

void* lsp_ldadd(void** slot, long delta);
void* lsp_ldaddal(void** slot, long delta);
void* lsp_swp(void** slot, void* v);
void* lsp_swpal(void** slot, void* v);
void* lsp_swp_int(void** slot, long v);
void* lsp_load(void** slot);
void lsp_stadd(void** slot, long delta);
void* lsp_ldset(void** slot, long v);
void* lsp_ldclr(void** slot, long v);
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

    /* ldadd: walk forward through the buffer, dereferencing every OLD hop */
    *slot = &buf[0];
    char* old = lsp_ldadd(slot, 5);
    ASSERT(old == &buf[0]);
    ASSERT(*old == 1);
    ASSERT(*slot == &buf[5]);
    old = lsp_ldadd(slot, 8);
    ASSERT(old == &buf[5]);
    ASSERT(*old == 6);
    ASSERT(*slot == &buf[13]);
    /* and backward (negative delta) */
    old = lsp_ldadd(slot, -3);
    ASSERT(old == &buf[13]);
    ASSERT(*old == 14);
    ASSERT(*slot == &buf[10]);
    ASSERT(lsp_deref(slot) == 11);

    /* the ldaddal ordering form */
    old = lsp_ldaddal(slot, 2);
    ASSERT(old == &buf[10]);
    ASSERT(*old == 11);
    ASSERT(*slot == &buf[12]);
    old = lsp_ldaddal(slot, -2);
    ASSERT(old == &buf[12]);
    ASSERT(*slot == &buf[10]);
    ASSERT(lsp_deref(slot) == 11);

    /* swp: exchange with a fresh pointer, old one comes back intact */
    old = lsp_swp(slot, &buf[30]);
    ASSERT(old == &buf[10]);
    ASSERT(*old == 11);
    ASSERT(*slot == &buf[30]);
    old = lsp_swp(slot, &buf[10]);
    ASSERT(old == &buf[30]);
    ASSERT(*old == 31);
    ASSERT(*slot == &buf[10]);
    /* swp with NULL */
    old = lsp_swp(slot, NULL);
    ASSERT(old == &buf[10]);
    ASSERT(*slot == NULL);
    old = lsp_swp(slot, &buf[10]);
    ASSERT(old == NULL);
    ASSERT(*slot == &buf[10]);

    /* CROSS-OBJECT exchange: the slot holds a pointer into buf; swp in a
       pointer into buf2, a DIFFERENT allocation. The stored pointer must
       carry buf2's (the SOURCE's) capability — dereferencing the slot must
       NOT trap — and the returned old pointer keeps buf's capability. */
    char* buf2 = malloc(64);
    ASSERT(buf2);
    for (i = 0; i < 64; i++)
        buf2[i] = (char)(i + 101);
    old = lsp_swp(slot, &buf2[20]);
    ASSERT(old == &buf[10]);
    ASSERT(*old == 11);                     /* old ptr -> buf dereferences */
    ASSERT(*slot == &buf2[20]);
    ASSERT(lsp_deref(slot) == 121);         /* new ptr -> buf2 dereferences */
    char* back = lsp_load(slot);            /* store-then-load the slot */
    ASSERT(back == &buf2[20]);
    ASSERT(*back == 121);
    /* and back the other way (the swpal ordering variant) */
    old = lsp_swpal(slot, &buf[40]);
    ASSERT(old == &buf2[20]);
    ASSERT(*old == 121);                    /* old ptr -> buf2 dereferences */
    ASSERT(*slot == &buf[40]);
    ASSERT(lsp_deref(slot) == 41);
    back = lsp_load(slot);
    ASSERT(back == &buf[40]);
    ASSERT(*back == 41);
    printf("cross-object swp ok\n");

    /* INTEGER source: swp a non-pointer value into the slot. It is stored
       with a null capability (legal — it just cannot be dereferenced); the
       exchange succeeds and the old pointer comes back intact. */
    old = lsp_swp_int(slot, 0x1234);
    ASSERT(old == &buf[40]);
    ASSERT(*old == 41);                     /* old pointer intact */
    ASSERT(*(uintptr_t*)slot == (uintptr_t)0x1234);   /* raw intval stored */
    old = lsp_swp(slot, &buf[10]);
    ASSERT((uintptr_t)old == (uintptr_t)0x1234);      /* intval came back */
    ASSERT(*slot == &buf[10]);
    ASSERT(lsp_deref(slot) == 11);
    printf("int swp ok\n");

    /* stadd: no old-value destination; the slot still walks atomically */
    lsp_stadd(slot, 5);
    ASSERT(*slot == &buf[15]);
    lsp_stadd(slot, -5);
    ASSERT(*slot == &buf[10]);
    ASSERT(lsp_deref(slot) == 11);

    /* ldset/ldclr on the intval, capability preserved: set the low bit of
       the address, then clear it again */
    uintptr_t saved = *(uintptr_t*)slot;
    ASSERT(saved == (uintptr_t)&buf[10]);
    old = lsp_ldset(slot, 1);
    ASSERT(old == (char*)saved);
    ASSERT(*(uintptr_t*)slot == (saved | 1));
    old = lsp_ldclr(slot, 1);
    ASSERT((uintptr_t)old == (saved | 1));      /* the OR'd intval came back */
    ASSERT(*(uintptr_t*)slot == saved);         /* fully restored */
    ASSERT(lsp_deref(slot) == 11);              /* capability survived */

    /* GC churn: the runtime CAS loop roots the old (iv, lo) pair across its
       per-iteration pollcheck/load/store safepoints */
    size_t repeat = 20000;
    if (zgc_is_stw())
        repeat = 1000;
    *slot = &buf[0];
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        old = lsp_ldadd(slot, 1);
        ASSERT(*old == (char)((old - buf) + 1));
        if (*slot == &buf[63])
            old = lsp_ldadd(slot, -63);
    }
    printf("aptr rmw arm ok\n");
    return 0;
}
