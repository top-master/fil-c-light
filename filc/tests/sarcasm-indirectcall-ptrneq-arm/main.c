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
    foo((long* (*)(long))((char*)bar + 1), 666);
    return 0;
}
