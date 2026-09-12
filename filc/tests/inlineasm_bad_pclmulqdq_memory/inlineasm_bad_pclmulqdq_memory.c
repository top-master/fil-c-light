#include <stdfil.h>

typedef unsigned long long v2di __attribute__((vector_size(16)));

int main(void)
{
    v2di a = { 3, 0 };
    unsigned long p = 5;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("pclmulqdq $0, (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
