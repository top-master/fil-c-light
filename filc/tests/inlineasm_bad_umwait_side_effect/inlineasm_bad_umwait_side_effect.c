#include <stdfil.h>
#include <stdint.h>

int main(void)
{
    uint32_t control = 0;
    uint64_t deadline = 0;
    uint32_t lo = (uint32_t)deadline;
    uint32_t hi = (uint32_t)(deadline >> 32);
    asm volatile("umwait %2" : : "a"(lo), "d"(hi), "r"(control) : "cc");
    return 0;
}
