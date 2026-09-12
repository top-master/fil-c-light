#include <stdio.h>
#include <string.h>

/* Too big to be atomically accessed natively, so the __atomic builtins on this
   struct call __atomic_compare_exchange & friends in libpizlo.so. */
struct S { int i; double d; char c[20]; long long l; };

static struct S shared;

static int is_v2(struct S* s)
{
    return s->i == 20 && s->d == 7.5 && !strcmp(s->c, "twenty") && s->l == 2000LL;
}

int main(void)
{
    struct S v1 = { 10, 3.5, "ten", 1000LL };
    struct S v2 = { 20, 7.5, "twenty", 2000LL };
    struct S v3 = { 30, 9.5, "thirty", 3000LL };
    struct S expected;
    struct S cur;
    _Bool ok;

    __atomic_store(&shared, &v1, __ATOMIC_SEQ_CST);

    /* Success path: expected matches the current value, so the swap happens and
       the operation returns true. */
    expected = v1;
    ok = __atomic_compare_exchange(&shared, &expected, &v2, 0,
                                   __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
    if (!ok) {
        printf("FAIL: compare_exchange should have succeeded\n");
        return 1;
    }
    __atomic_load(&shared, &cur, __ATOMIC_SEQ_CST);
    if (!is_v2(&cur)) {
        printf("FAIL: compare_exchange succeeded but value not swapped\n");
        return 1;
    }
    printf("success path: ok = %d, cur.i = %d\n", (int)ok, cur.i);

    /* Failure path: expected does not match the current value, so the swap does
       not happen, the operation returns false, and expected is reloaded with the
       current value. */
    expected = v1;
    ok = __atomic_compare_exchange(&shared, &expected, &v3, 0,
                                   __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST);
    if (ok) {
        printf("FAIL: compare_exchange should have failed\n");
        return 1;
    }
    if (!is_v2(&expected)) {
        printf("FAIL: compare_exchange failure did not reload expected\n");
        return 1;
    }
    __atomic_load(&shared, &cur, __ATOMIC_SEQ_CST);
    if (!is_v2(&cur)) {
        printf("FAIL: compare_exchange failed but value changed anyway\n");
        return 1;
    }
    printf("failure path: ok = %d, expected.i = %d\n", (int)ok, expected.i);
    printf("success\n");
    return 0;
}
