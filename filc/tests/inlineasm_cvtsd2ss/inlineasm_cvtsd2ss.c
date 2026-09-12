#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v2df a = { 3.14, 0.0 };
    v4sf b = { 1.0f, 2.0f, 3.0f, 4.0f };

    asm volatile("cvtsd2ss %1, %0" : "+x"(b) : "x"(a));

    ZASSERT(b[0] == 3.14f);
    ZASSERT(b[1] == 2.0f);
    ZASSERT(b[2] == 3.0f);
    ZASSERT(b[3] == 4.0f);

    return 0;
}
