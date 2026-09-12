#include <stdfil.h>

int main(void)
{
    unsigned int lo;
    asm volatile("rdtsc" : "=a"(lo));
    return 0;
}
