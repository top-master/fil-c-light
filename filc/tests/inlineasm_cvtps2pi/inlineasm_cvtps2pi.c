#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef int v2si __attribute__((vector_size(8)));

int main(void)
{
    v4sf a = { 3.0f, -2.0f, 99.0f, 100.0f };
    v2si b;

    asm volatile("cvtps2pi %1, %0" : "=y"(b) : "x"(a));

    ZASSERT(b[0] == 3);
    ZASSERT(b[1] == -2);

    return 0;
}
