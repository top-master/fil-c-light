#include <stdio.h>
#include <string.h>

/* Too big to be atomically accessed natively, so the __atomic builtins on this
   struct call __atomic_store/__atomic_exchange/__atomic_load in libpizlo.so. */
struct S { int i; double d; char c[20]; long long l; };

static struct S shared;

int main(void)
{
    struct S first = { 1, 1.5, "first", 111LL };
    struct S second = { 2, 2.5, "second", 222LL };
    struct S old;
    struct S cur;

    __atomic_store(&shared, &first, __ATOMIC_SEQ_CST);

    memset(&old, 0, sizeof(old));
    __atomic_exchange(&shared, &second, &old, __ATOMIC_SEQ_CST);

    if (old.i != 1 || old.d != 1.5 || strcmp(old.c, "first") || old.l != 111LL) {
        printf("FAIL: exchanged-out value is wrong\n");
        return 1;
    }

    __atomic_load(&shared, &cur, __ATOMIC_SEQ_CST);
    if (cur.i != 2 || cur.d != 2.5 || strcmp(cur.c, "second") || cur.l != 222LL) {
        printf("FAIL: exchanged-in value is wrong\n");
        return 1;
    }

    printf("old = { %d, %g, \"%s\", %lld }\n", old.i, old.d, old.c, old.l);
    printf("cur = { %d, %g, \"%s\", %lld }\n", cur.i, cur.d, cur.c, cur.l);
    printf("success\n");
    return 0;
}
