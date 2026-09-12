#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = {0};
    unsigned long p = 0;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("pblendw $0x55, (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
