#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v2df a = { 3.14, 2.72 };
    v4sf b = { 1.5f, 2.0f, 3.0f, 4.0f };

    asm volatile("cvtss2sd %1, %0" : "+x"(a) : "x"(b));

    ZASSERT(a[0] == 1.5);
    ZASSERT(a[1] == 2.72);

    return 0;
}
