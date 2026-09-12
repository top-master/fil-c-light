#include <stdfil.h>

int main(void)
{
    unsigned long src;
    unsigned long dest;

    src = 0x8000000000000000ull;
    asm volatile("tzcntq %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 63);

    src = 0x1000000000000000ull;
    asm volatile("tzcntq %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 60);

    src = 0x1;
    asm volatile("tzcntq %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 0);

    src = 0;
    asm volatile("tzcntq %1, %0"
                 : "=r"(dest)
                 : "r"(src)
                 : "cc");
    ZASSERT(dest == 64);

    unsigned int src32;
    unsigned int dest32;
    src32 = 0x80000000;
    asm volatile("tzcntl %1, %0"
                 : "=r"(dest32)
                 : "r"(src32)
                 : "cc");
    ZASSERT(dest32 == 31);

    src32 = 0x10000000;
    asm volatile("tzcntl %1, %0"
                 : "=r"(dest32)
                 : "r"(src32)
                 : "cc");
    ZASSERT(dest32 == 28);

    src32 = 0;
    asm volatile("tzcntl %1, %0"
                 : "=r"(dest32)
                 : "r"(src32)
                 : "cc");
    ZASSERT(dest32 == 32);

    return 0;
}
