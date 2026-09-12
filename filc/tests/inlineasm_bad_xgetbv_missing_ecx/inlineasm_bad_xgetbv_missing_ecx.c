#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    uint32_t lo, hi;
    asm("xgetbv" : "=a"(lo), "=d"(hi));
    zprintf("lo = %u\n", lo);
    return 0;
}
