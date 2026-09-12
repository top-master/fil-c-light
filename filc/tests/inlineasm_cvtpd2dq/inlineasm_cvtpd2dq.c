#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v2df a = { 3.0, -2.0 };
    v4si b;

    asm volatile("cvtpd2dq %1, %0" : "=x"(b) : "x"(a));

    ZASSERT(b[0] == 3);
    ZASSERT(b[1] == -2);

    return 0;
}
