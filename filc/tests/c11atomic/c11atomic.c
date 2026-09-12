#include <stdfil.h>

int main()
{
    int	x;
    int*_Atomic p = &x;
    int* q = __c11_atomic_fetch_sub(&p, 42, __ATOMIC_SEQ_CST);
    ZASSERT(q == &x);
    ZASSERT(p == &x - 42);
    q = __c11_atomic_fetch_add(&p, 666, __ATOMIC_SEQ_CST);
    ZASSERT(q == &x - 42);
    ZASSERT(p == &x + 666 - 42);
    return 0;
}

