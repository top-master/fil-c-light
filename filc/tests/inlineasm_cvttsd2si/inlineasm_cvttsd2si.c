#include <stdfil.h>

int main(void)
{
    double a = 3.9;
    int iresult;
    long lresult;

    asm volatile("cvttsd2si %1, %0" : "=r"(iresult) : "x"(a));
    ZASSERT(iresult == 3);

    asm volatile("cvttsd2si %1, %0" : "=r"(lresult) : "x"(a));
    ZASSERT(lresult == 3);

    return 0;
}
