#include <stdfil.h>
#include <stddef.h>

int foo(int* (*f)(int), int a);

int main()
{
    foo(NULL, 666);
    return 0;
}
