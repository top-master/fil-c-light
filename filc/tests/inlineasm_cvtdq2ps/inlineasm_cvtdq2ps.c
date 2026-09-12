#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));
typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4si a = { 3, -2, 0, 5 };
    v4sf b;

    asm volatile("cvtdq2ps %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3.0f);
    ZASSERT(b[1] == -2.0f);
    ZASSERT(b[2] == 0.0f);
    ZASSERT(b[3] == 5.0f);

    return 0;
}
