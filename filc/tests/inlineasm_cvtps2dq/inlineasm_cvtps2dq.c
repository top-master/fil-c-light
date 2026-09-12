#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));
typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 3.7f, -2.2f, 0.0f, 5.9f };
    v4si b;

    asm volatile("cvtps2dq %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 4);
    ZASSERT(b[1] == -2);
    ZASSERT(b[2] == 0);
    ZASSERT(b[3] == 6);

    return 0;
}
