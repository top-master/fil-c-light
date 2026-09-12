#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));

int main(void)
{
    v8hi a = { -1, 2, -3, 4, -32767, 6, -7, 8 };
    v8hi b;

    asm volatile("pabsw %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 1);
    ZASSERT(b[1] == 2);
    ZASSERT(b[2] == 3);
    ZASSERT(b[3] == 4);
    ZASSERT(b[4] == 32767);
    ZASSERT(b[5] == 6);
    ZASSERT(b[6] == 7);
    ZASSERT(b[7] == 8);

    return 0;
}
