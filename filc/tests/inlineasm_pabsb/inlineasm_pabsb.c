#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = { -1, 2, -3, 4, -5, 6, -7, 8,
                -9, 10, -11, 12, -13, 14, -15, 16 };
    v16qi b;

    asm volatile("pabsb %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 1);
    ZASSERT(b[1] == 2);
    ZASSERT(b[2] == 3);
    ZASSERT(b[3] == 4);
    ZASSERT(b[4] == 5);
    ZASSERT(b[5] == 6);
    ZASSERT(b[6] == 7);
    ZASSERT(b[7] == 8);
    ZASSERT(b[8] == 9);
    ZASSERT(b[9] == 10);
    ZASSERT(b[10] == 11);
    ZASSERT(b[11] == 12);
    ZASSERT(b[12] == 13);
    ZASSERT(b[13] == 14);
    ZASSERT(b[14] == 15);
    ZASSERT(b[15] == 16);

    return 0;
}
