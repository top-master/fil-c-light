#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef int v2si __attribute__((vector_size(8)));

int main(void)
{
    v2df a = { 3.0, -2.0 };
    v2si b;

    asm volatile("cvtpd2pi %1, %0" : "=y"(b) : "x"(a));

    ZASSERT(b[0] == 3);
    ZASSERT(b[1] == -2);

    return 0;
}
