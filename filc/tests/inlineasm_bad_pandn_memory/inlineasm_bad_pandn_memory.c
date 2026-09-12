#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = { 0, 1, 2, 3, 4, 5, 6, 7,
                8, 9, 10, 11, 12, 13, 14, 15 };
    unsigned long p = 0;
    /* Memory operands are not supported in inline assembly. */
    asm volatile("pandn (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
