#include <stdfil.h>

int main(void)
{
    unsigned long src;
    unsigned long index;
    unsigned long dest;

    src = 0x12345678;
    index = 8;
    asm volatile("bzhi %1, %2, %0"
                 : "=r"(dest)
                 : "r"(index), "r"(src)
                 : "cc");
    ZASSERT(dest == 0x78);

    src = 0xffffffff;
    index = 16;
    asm volatile("bzhi %1, %2, %0"
                 : "=r"(dest)
                 : "r"(index), "r"(src)
                 : "cc");
    ZASSERT(dest == 0xffff);

    src = 0;
    index = 8;
    asm volatile("bzhi %1, %2, %0"
                 : "=r"(dest)
                 : "r"(index), "r"(src)
                 : "cc");
    ZASSERT(dest == 0);

    src = 0xfffffffffffffffful;
    index = 0;
    asm volatile("bzhi %1, %2, %0"
                 : "=r"(dest)
                 : "r"(index), "r"(src)
                 : "cc");
    ZASSERT(dest == 0);

    return 0;
}
