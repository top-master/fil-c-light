#include <stdfil.h>

extern int __attribute__((weak)) foo;
int* bar = &foo;

int main()
{
    ZASSERT(!bar);
    return 0;
}
