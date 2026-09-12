#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v2df a = { 3.0, -2.0 };
    v4sf b;

    asm volatile("cvtpd2ps %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3.0f);
    ZASSERT(b[1] == -2.0f);
    ZASSERT(b[2] == 0.0f);
    ZASSERT(b[3] == 0.0f);

    return 0;
}
