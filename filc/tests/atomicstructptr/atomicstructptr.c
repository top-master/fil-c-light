#include <stdio.h>

/* A 16-byte struct containing a pointer, with only 8-byte alignment (deliberately NOT
   _Atomic, since _Atomic would promote the alignment to 16). Atomic operations on this
   cannot use cmpxchg16b, which requires 16-byte alignment, so a pre-pass in the pizlonator
   (convertMisalignedAtomicsToLibcalls in FilPizlonator.cpp) converts them into calls to
   __atomic_load & friends, which are implemented in libpizlo (see filc/src/runtime.c).

   Note that the capabilities of pointers inside such flattened-integer atomics are lost
   (the frontend emits the atomic as an i128 operation, and an integer SSA value cannot
   carry a capability) - the same thing happens for aligned 16-byte atomics. So this test
   checks that pointer payloads (addresses) round-trip correctly, which they must; pointer
   comparisons compare addresses, so they work fine here. */
struct S { void* p; long l; };

static struct S g;
static int x = 42;
static int y = 99;

int main(void)
{
    _Static_assert(sizeof(struct S) == 16, "S is 16 bytes");
    _Static_assert(_Alignof(struct S) == 8, "S has 8-byte alignment");

    struct S v = { &x, 1234 };
    __atomic_store(&g, &v, __ATOMIC_SEQ_CST);

    struct S check = { 0, 0 };
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.p != &x || check.l != 1234) {
        printf("FAIL: load returned { %p, %ld }\n", check.p, check.l);
        return 1;
    }

    struct S v2 = { &y, 5678 };
    struct S old = { 0, 0 };
    __atomic_exchange(&g, &v2, &old, __ATOMIC_SEQ_CST);
    if (old.p != &x || old.l != 1234) {
        printf("FAIL: exchange returned { %p, %ld }\n", old.p, old.l);
        return 1;
    }
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.p != &y || check.l != 5678) {
        printf("FAIL: load after exchange returned { %p, %ld }\n", check.p, check.l);
        return 1;
    }

    /* Successful compare-exchange. */
    struct S expected = { &y, 5678 };
    struct S desired = { &x, 4321 };
    if (!__atomic_compare_exchange(&g, &expected, &desired, 0,
                                   __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST)) {
        printf("FAIL: compare-exchange failed unexpectedly\n");
        return 1;
    }
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.p != &x || check.l != 4321) {
        printf("FAIL: load after compare-exchange returned { %p, %ld }\n", check.p, check.l);
        return 1;
    }

    /* Failed compare-exchange: g is left unchanged and expected is overwritten with the
       current value. */
    struct S wrong = { 0, 0 };
    if (__atomic_compare_exchange(&g, &wrong, &v2, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST)) {
        printf("FAIL: compare-exchange succeeded unexpectedly\n");
        return 1;
    }
    if (wrong.p != &x || wrong.l != 4321) {
        printf("FAIL: failed compare-exchange set expected to { %p, %ld }\n", wrong.p, wrong.l);
        return 1;
    }
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.p != &x || check.l != 4321) {
        printf("FAIL: failed compare-exchange modified g to { %p, %ld }\n", check.p, check.l);
        return 1;
    }

    printf("g = { %p, %ld }\n", check.p, check.l);
    printf("check.p == &x: %d\n", check.p == &x);
    printf("success\n");
    return 0;
}
