#include <stdfil.h>

int foo(int* (**fp)(int), int a);

int* bar(int a)
{
    int* result = zgc_alloc(sizeof(int));
    *result = a;
    return result;
}

int main()
{
    int* (*fp)(int) = bar;
    ZASSERT(foo(&fp, 666) == 666 + 1 + 67);
    return 0;
}
