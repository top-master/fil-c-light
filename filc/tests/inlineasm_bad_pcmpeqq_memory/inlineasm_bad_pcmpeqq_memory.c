#include <stdfil.h>

typedef long long v2di __attribute__((vector_size(16)));

int main(void)
{
    v2di a = { 0, 1 };
    unsigned long p = 0;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("pcmpeqq (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
