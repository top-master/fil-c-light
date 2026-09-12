#include <stdfil.h>

static __attribute__((noinline)) void foo(char* a, char* b)
{
    zprintf("result = %d\n", (int)a[b - a - 1]);
}

int main()
{
    char array[10];
    for (unsigned i = 0; i < 10; ++i)
        array[i] = i + 1;
    foo(array + 5, array + 6);
    return 0;
}

