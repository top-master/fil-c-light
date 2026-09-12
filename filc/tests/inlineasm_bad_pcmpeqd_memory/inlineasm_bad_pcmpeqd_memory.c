#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4si a = { 0, 1, 2, 3 };
    unsigned long p = 0;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("pcmpeqd (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
