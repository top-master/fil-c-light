#include <stdfil.h>

int main(void)
{
    unsigned long x;
    unsigned long y;

    x = 10;
    y = 5;
    asm volatile("cmp %1, %0"
                 :: "r"(x), "r"(y)
                 : "cc");
    ZASSERT(x == 10);
    ZASSERT(y == 5);

    x = 5;
    y = 10;
    asm volatile("cmp %1, %0"
                 :: "r"(x), "r"(y)
                 : "cc");
    ZASSERT(x == 5);
    ZASSERT(y == 10);

    x = 0;
    y = 0;
    asm volatile("cmp %1, %0"
                 :: "r"(x), "r"(y)
                 : "cc");
    ZASSERT(x == 0);
    ZASSERT(y == 0);

    return 0;
}
