#include <stdfil.h>

extern int __attribute__((weak)) foo;
int* bar = &foo;

int main()
{
    ZASSERT(bar);
    ZASSERT(*bar == 666);
    return 0;
}
