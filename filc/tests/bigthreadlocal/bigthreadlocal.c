#include <stdfil.h>

_Thread_local char big[2097152];

int main()
{
    asm volatile ("" : : : "memory");
    ZASSERT(!big[0]);
    asm volatile ("" : : : "memory");
    big[0] = 42;
    asm volatile ("" : : : "memory");
    ZASSERT(big[0] == 42);
    return 0;
}

