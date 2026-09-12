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
    foo((int* (*)(int))((char*)bar + 1), 666);
    return 0;
}
