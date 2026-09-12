#include <stdfil.h>
#include <stdbool.h>
#include <inttypes.h>
#include <stdlib.h>

static __attribute__((noinline)) uintptr_t foo(bool p, bool q, bool r, void* s, uintptr_t i)
{
    union {
        uintptr_t* p;
        uintptr_t i[2];
    } u;
    u.i[0] = i;
    u.i[1] = i + 1;
    if (p) {
        u.p = malloc(sizeof(uintptr_t));
        *u.p = 42;
    }
    if (r)
        u.p += (uintptr_t)s;
    if (q)
        return *u.p;
    else
        return u.i[0] + u.i[1];
}

int main()
{
    uintptr_t result = foo(true, true, true, NULL, 666);
    zprintf("result = %zu\n", (size_t)result);
    ZASSERT(result == 42);
    return 0;
}

