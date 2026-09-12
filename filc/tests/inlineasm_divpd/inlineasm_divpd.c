#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

int main(void)
{
    v2df a = { 4.0, 1.0 };
    v2df b = { 2.0, 0.5 };

    asm volatile("divpd %1, %0" : "+x"(a) : "x"(b));

    ZASSERT(a[0] == 2.0);
    ZASSERT(a[1] == 2.0);

    return 0;
}
