#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4si a = { -3, 0, -2147483647, 42 };
    v4si b;

    asm volatile("pabsd %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3);
    ZASSERT(b[1] == 0);
    ZASSERT(b[2] == 2147483647);
    ZASSERT(b[3] == 42);

    return 0;
}
