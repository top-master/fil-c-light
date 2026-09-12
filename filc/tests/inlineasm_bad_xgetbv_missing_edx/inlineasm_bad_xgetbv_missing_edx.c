#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    uint32_t lo;
    asm("xgetbv" : "=a"(lo) : "c"(0));
    zprintf("lo = %u\n", lo);
    return 0;
}
