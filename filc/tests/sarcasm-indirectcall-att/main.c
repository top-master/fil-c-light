#include <stdfil.h>

int foo(int* (*f)(int), int a);

int* bar(int a)
{
    int* result = zgc_alloc(sizeof(int));
    *result = a;
    return result;
}

int main()
{
    ZASSERT(foo(bar, 666) == 666 + 1 + 67);
    return 0;
}
