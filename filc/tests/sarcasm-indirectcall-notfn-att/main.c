#include <stdfil.h>

int foo(int* (*f)(int), int a);

int main()
{
    int* p = zgc_alloc(sizeof(int));
    *p = 42;
    foo((int* (*)(int))p, 666);
    return 0;
}
