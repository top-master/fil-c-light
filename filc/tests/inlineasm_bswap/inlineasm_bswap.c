#include <stdfil.h>

int main(void)
{
    unsigned long x64;
    unsigned int x32;

    x64 = 0x0102030405060708ull;
    asm volatile("bswapq %0" : "+r"(x64));
    ZASSERT(x64 == 0x0807060504030201ull);

    x32 = 0x12345678;
    asm volatile("bswapl %0" : "+r"(x32));
    ZASSERT(x32 == 0x78563412);

    x64 = 0x0102030405060708ull;
    asm volatile("bswap %0" : "+r"(x64));
    ZASSERT(x64 == 0x0807060504030201ull);

    return 0;
}
