#include <stdfil.h>

long foo(long* (*f)(long), long a);

int main()
{
    long* p = zgc_alloc(sizeof(long));
    *p = 42;
    foo((long* (*)(long))p, 666);
    return 0;
}
