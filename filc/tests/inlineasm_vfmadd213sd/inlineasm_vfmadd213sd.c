#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v2df a = { 2.0, 3.0 };
    v2df b = { 4.0, 5.0 };
    v2df c = { 6.0, 7.0 };

    asm volatile("vfmadd213sd %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    ZASSERT(a[0] == 14.0);
    ZASSERT(a[1] == 3.0);

    return 0;
}
