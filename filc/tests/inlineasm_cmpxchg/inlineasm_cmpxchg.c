#include <stdfil.h>

int main(void)
{
    unsigned long dest;
    unsigned long src;
    unsigned long cmp;

    dest = 10;
    src = 42;
    cmp = 10;
    asm volatile("cmpxchg %2, %0"
                 : "+r"(dest), "+a"(cmp)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 42);
    ZASSERT(cmp == 10);

    dest = 10;
    src = 42;
    cmp = 5;
    asm volatile("cmpxchg %2, %0"
                 : "+r"(dest), "+a"(cmp)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 10);
    ZASSERT(cmp == 10);

    return 0;
}
