#include <stdfil.h>

int* foo(int* x)
{
    int* y = x + 5;
    asm volatile("" : "=r"(x), "+r"(y) : : "memory");
    ZASSERT(!zgetlower(x));
    ZASSERT(!zgetupper(x));
    ZASSERT(!zhasvalidcap(x));
    return y + 6;
}

int main(void)
{
    int x = 666;
    int* result = foo(&x);
    ZASSERT(result == &x + 5 + 6);
    ZASSERT(zgetlower(result) == zgetlower(&x));
    ZASSERT(zgetupper(result) == zgetupper(&x));
    return 0;
}

