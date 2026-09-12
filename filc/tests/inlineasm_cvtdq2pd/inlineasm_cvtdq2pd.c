#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));
typedef double v2df __attribute__((vector_size(16)));

int main(void)
{
    v4si a = { 3, -2, 0, 0 };
    v2df b;

    asm volatile("cvtdq2pd %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3.0);
    ZASSERT(b[1] == -2.0);

    return 0;
}
