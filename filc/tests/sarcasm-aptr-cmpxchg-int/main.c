/* `;! atomic ptr` on cmpxchgq: pointer compare-exchange through the runtime.
   Success path (slot == expected: exchanged, ZF set, rax = old), failure path
   (slot != expected: not exchanged, ZF clear, rax = old value WITH capability —
   dereferenced below), the lock form, an explicit ZF consumer, and the
   loop-until-success idiom. */
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

void* ap_cas(void** slotpair, void* expected);
void* ap_cas_lock(void** slotpair, void* expected);
long ap_cas_zf(void** slotpair, void* expected);
void* ap_add(void** slot, long delta);

int main()
{
    char* buf = malloc(64);
    size_t i;
    ASSERT(buf);
    for (i = 0; i < 64; i++)
        buf[i] = (char)(i + 1);
    void** sp = malloc(2 * sizeof(void*));
    ASSERT(sp);

    /* success: slot == expected -> exchanged, old returned with capability */
    sp[0] = &buf[0];
    sp[1] = &buf[5];
    char* old = ap_cas(sp, &buf[0]);
    ASSERT(old == &buf[0]);
    ASSERT(*old == 1);              /* dereference: the capability works */
    ASSERT(sp[0] == &buf[5]);

    /* failure: slot != expected -> not exchanged, old value returned (deref) */
    sp[1] = &buf[7];
    old = ap_cas(sp, &buf[0]);      /* slot holds &buf[5], expected &buf[0] */
    ASSERT(old == &buf[5]);
    ASSERT(*old == 6);
    ASSERT(sp[0] == &buf[5]);       /* unchanged */

    /* ZF consumer immediately after the annotated cmpxchg */
    sp[0] = &buf[10];
    sp[1] = &buf[11];
    ASSERT(ap_cas_zf(sp, &buf[10]) == 1);   /* match -> exchanged, ZF=1 */
    ASSERT(sp[0] == &buf[11]);
    ASSERT(ap_cas_zf(sp, &buf[10]) == 0);   /* mismatch -> ZF=0 */
    ASSERT(sp[0] == &buf[11]);

    /* lock form: success and failure */
    sp[0] = &buf[2];
    sp[1] = &buf[9];
    old = ap_cas_lock(sp, &buf[2]);
    ASSERT(old == &buf[2]);
    ASSERT(sp[0] == &buf[9]);
    old = ap_cas_lock(sp, &buf[2]);
    ASSERT(old == &buf[9]);
    ASSERT(*old == 10);
    ASSERT(sp[0] == &buf[9]);

    /* expected with a null lower is a legitimate "integer guess": the runtime
       compares expected by intval only. An inttoptr has a null capability. */
    sp[0] = &buf[20];
    sp[1] = &buf[21];
    void* guess = (void*)(size_t)&buf[20];      /* null-lower expected */
    old = ap_cas(sp, guess);
    ASSERT(old == &buf[20]);
    ASSERT(*old == 21);                          /* real lower came back */
    ASSERT(sp[0] == &buf[21]);

    /* the loop-until-success idiom: walk the pointer through the buffer,
       dereferencing after every step (capability preserved each hop) */
    void** slot = malloc(sizeof(void*));
    ASSERT(slot);
    *slot = &buf[0];
    old = ap_add(slot, 3);
    ASSERT(old == &buf[0]);
    ASSERT(*slot == &buf[3]);
    ASSERT(*(char*)*slot == 4);
    for (i = 0; i < 50; i++)
        old = ap_add(slot, 1);
    ASSERT(old == &buf[52]);
    ASSERT(*slot == &buf[53]);
    ASSERT(*(char*)*slot == 54);

    /* the same idiom driven from C: compare-exchange until it succeeds */
    sp[0] = &buf[0];
    sp[1] = &buf[40];
    void* cur;
    do {
        cur = sp[0];
    } while (!ap_cas_zf(sp, cur));
    ASSERT(sp[0] == &buf[40]);
    ASSERT(*(char*)sp[0] == 41);

    /* under allocation churn (GC marking), the boxed slot and the per-call
       root slots keep working */
    size_t repeat = 50000;
    if (zgc_is_stw())
        repeat = 1000;
    *slot = &buf[0];
    for (i = 0; i < repeat; i++) {
        void* junk = malloc(64);
        memset(junk, 1, 64);
        free(junk);
        old = ap_add(slot, 0);          /* no-op RMW: exercises the full CAS path */
        ASSERT(old == &buf[0]);
        ASSERT(*(char*)old == 1);
    }
    printf("aptr cmpxchg int ok\n");
    return 0;
}
