#include <stdfil.h>

static void cleanup(int* x)
{
    zprintf("in cleanup, x = %d\n", *x);
}

static void cleanup2(int* y)
{
    zprintf("in cleanup, y = %d\n", *y);
}

void bar(void);

void foo(void)
{
    int x __attribute__((__cleanup__(cleanup))) = 42;
    x = 666;
    {
        int y __attribute__((__cleanup__(cleanup2))) = 100;
        y = 200;
        bar();
        y = 1001;
    }
    x = 1000;
}
