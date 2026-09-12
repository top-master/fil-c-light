#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    uint32_t leaf = 0;
    uint32_t subleaf = 0;
    uint32_t a, c, d;
    asm("cpuid" : "=a"(a), "=c"(c), "=d"(d) : "a"(leaf), "c"(subleaf));
    zprintf("a = %u\n", a);
    return 0;
}
