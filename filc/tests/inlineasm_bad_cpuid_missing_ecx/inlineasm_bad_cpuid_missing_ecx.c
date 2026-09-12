#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    uint32_t leaf = 0;
    uint32_t a, b, d;
    asm("cpuid" : "=a"(a), "=b"(b), "=d"(d) : "a"(leaf));
    zprintf("a = %u\n", a);
    return 0;
}
