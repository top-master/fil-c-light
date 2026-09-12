#include <stdio.h>
#include <string.h>

static _Atomic int x;

struct S { int i; double d; char c[20]; long long l; };

static _Atomic struct S s1, s2;

int main(void)
{
    int a = ++x;
    int b = ++x;

    /* This store goes through __atomic_store in libpizlo.so since struct S is too
       big to be atomically accessed natively. */
    struct S v = { 42, 6.25, "hello world", 1000000000000LL };
    s1 = v;

    /* This copy is an atomic load of s1 plus an atomic store to s2, both via
       libcalls. */
    s2 = s1;

    struct S check = s2;
    if (check.i != 42 || check.d != 6.25 || strcmp(check.c, "hello world") ||
        check.l != 1000000000000LL) {
        printf("FAIL: atomic struct copy corrupted\n");
        return 1;
    }
    if (a != 1 || b != 2) {
        printf("FAIL: atomic int increment broken\n");
        return 1;
    }
    printf("a = %d, b = %d\n", a, b);
    printf("s2 = { %d, %g, \"%s\", %lld }\n", check.i, check.d, check.c, check.l);
    printf("success\n");
    return 0;
}
