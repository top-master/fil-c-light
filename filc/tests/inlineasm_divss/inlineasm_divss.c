#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 10.0f, 2.0f, 3.0f, 4.0f };
    v4sf b = { 2.0f, 6.0f, 7.0f, 8.0f };

    asm volatile("divss %1, %0" : "+x"(a) : "x"(b));

    ZASSERT(a[0] == 5.0f);
    ZASSERT(a[1] == 2.0f);
    ZASSERT(a[2] == 3.0f);
    ZASSERT(a[3] == 4.0f);

    return 0;
}
