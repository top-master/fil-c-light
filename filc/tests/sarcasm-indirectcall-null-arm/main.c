#include <stdfil.h>
#include <stddef.h>

long foo(long* (*f)(long), long a);

int main()
{
    foo(NULL, 666);
    return 0;
}
