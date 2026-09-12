#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));

__attribute__((target("ssse3"))) int main(void)
{
    v8hi a = { 0, 1, 2, 3, 4, 5, 6, 7 };
    unsigned long p = 0;
    asm volatile("phaddw (%1), %0" : "+x"(a) : "r"(p));
    return 0;
}
