#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 3.7f, -2.1f, 99.9f, -100.2f };
    v4si b;

    asm volatile("cvttps2dq %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3);
    ZASSERT(b[1] == -2);
    ZASSERT(b[2] == 99);
    ZASSERT(b[3] == -100);

    return 0;
}
