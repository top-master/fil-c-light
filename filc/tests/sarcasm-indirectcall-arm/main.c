#include <stdfil.h>

long foo(long* (*f)(long), long a);

long* bar(long a)
{
    long* result = zgc_alloc(sizeof(long));
    *result = a;
    return result;
}

int main()
{
    ZASSERT(foo(bar, 666) == 666 + 1 + 67);
    return 0;
}
