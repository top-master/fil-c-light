#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef double v2df __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 3.5f, -2.25f, 99.0f, 100.0f };
    v2df b;

    asm volatile("cvtps2pd %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3.5);
    ZASSERT(b[1] == -2.25);

    return 0;
}
