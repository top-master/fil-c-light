#include <stdfil.h>

static void cleanup(int* x)
{
    zprintf("in cleanup, x = %d\n", *x);
}

void bar(void);

void foo(void)
{
    int x __attribute__((__cleanup__(cleanup))) = 42;
    x = 666;
    bar();
}
