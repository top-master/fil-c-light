#include <stdfil.h>

long foo(long* (* volatile *f)(long), long a);

long* bar(long a)
{
    long* result = zgc_alloc(sizeof(long));
    *result = a;
    return result;
}

int main()
{
    long* (*fp)(long) = bar;
    ZASSERT(foo(&fp, 666) == 666 + 1 + 67);
    return 0;
}
