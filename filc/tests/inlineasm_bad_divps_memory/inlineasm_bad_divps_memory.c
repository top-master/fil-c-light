#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = {8.0f, 6.0f, 4.0f, 2.0f};
    unsigned long p = 0;
    asm volatile("divps (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
