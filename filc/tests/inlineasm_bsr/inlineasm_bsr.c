#include <stdfil.h>

int main(void)
{
    unsigned long src;
    unsigned long dest;

    src = 0x110;
    asm volatile("bsr %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 8);

    src = 0x1;
    asm volatile("bsr %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 0);

    src = 0;
    asm volatile("bsrq %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");

    src = 0x8000000000000000ull;
    asm volatile("bsrq %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 63);

    unsigned int src32;
    unsigned int dest32;
    src32 = 0x10000;
    asm volatile("bsrl %1, %0"
                 : "=r"(dest32)
                 : "r"(src32)
                 : "cc");
    ZASSERT(dest32 == 16);

    return 0;
}
