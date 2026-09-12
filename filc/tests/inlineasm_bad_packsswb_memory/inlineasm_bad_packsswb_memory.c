#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));

int main(void)
{
    v8hi a = { 1, 2, 3, 4, 5, 6, 7, 8 };
    unsigned long p = 0;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("packsswb (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
