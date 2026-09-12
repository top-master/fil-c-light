#include <stdio.h>

/* An 8-byte struct with only 4-byte alignment (deliberately NOT _Atomic, since _Atomic would
   promote the alignment to 8). Atomic operations on this cannot be done natively, so a
   pre-pass in the pizlonator (convertMisalignedAtomicsToLibcalls in FilPizlonator.cpp)
   converts them into calls to __atomic_load, __atomic_store, __atomic_exchange, and
   __atomic_compare_exchange, which are implemented in libpizlo (see filc/src/runtime.c). */
struct S { int a, b; };

static struct S g;

int main(void)
{
    _Static_assert(sizeof(struct S) == 8, "S is 8 bytes");
    _Static_assert(_Alignof(struct S) == 4, "S has 4-byte alignment");

    struct S v = { 111, 222 };
    __atomic_store(&g, &v, __ATOMIC_SEQ_CST);

    struct S check = { 0, 0 };
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.a != 111 || check.b != 222) {
        printf("FAIL: load returned { %d, %d }\n", check.a, check.b);
        return 1;
    }

    struct S v2 = { 333, 444 };
    struct S old = { 0, 0 };
    __atomic_exchange(&g, &v2, &old, __ATOMIC_SEQ_CST);
    if (old.a != 111 || old.b != 222) {
        printf("FAIL: exchange returned { %d, %d }\n", old.a, old.b);
        return 1;
    }
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.a != 333 || check.b != 444) {
        printf("FAIL: load after exchange returned { %d, %d }\n", check.a, check.b);
        return 1;
    }

    /* Successful compare-exchange. */
    struct S expected = { 333, 444 };
    struct S desired = { 555, 666 };
    if (!__atomic_compare_exchange(&g, &expected, &desired, 0,
                                   __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST)) {
        printf("FAIL: compare-exchange failed unexpectedly\n");
        return 1;
    }
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.a != 555 || check.b != 666) {
        printf("FAIL: load after compare-exchange returned { %d, %d }\n", check.a, check.b);
        return 1;
    }

    /* Failed compare-exchange: g is left unchanged and expected is overwritten with the
       current value. */
    struct S wrong = { 1, 2 };
    if (__atomic_compare_exchange(&g, &wrong, &v, 0, __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST)) {
        printf("FAIL: compare-exchange succeeded unexpectedly\n");
        return 1;
    }
    if (wrong.a != 555 || wrong.b != 666) {
        printf("FAIL: failed compare-exchange set expected to { %d, %d }\n", wrong.a, wrong.b);
        return 1;
    }
    __atomic_load(&g, &check, __ATOMIC_SEQ_CST);
    if (check.a != 555 || check.b != 666) {
        printf("FAIL: failed compare-exchange modified g to { %d, %d }\n", check.a, check.b);
        return 1;
    }

    printf("g = { %d, %d }\n", check.a, check.b);
    printf("success\n");
    return 0;
}
