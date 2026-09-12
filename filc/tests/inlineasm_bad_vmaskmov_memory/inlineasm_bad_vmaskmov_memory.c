#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf mask = {0.0, 0.0, 0.0, 0.0};
    unsigned long p = 0;
    v4sf res;
    /* VMASKMOVPS is a conditional SIMD packed load/store. Every form requires
       a memory operand, so it is unsafe for inline asm. */
    asm volatile("vmaskmovps (%2), %1, %0" : "=x"(res) : "x"(mask), "r"(p));
    return 0;
}
