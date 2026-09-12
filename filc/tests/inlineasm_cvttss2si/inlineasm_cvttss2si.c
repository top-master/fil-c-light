#include <stdfil.h>

int main(void)
{
    float a = 3.9f;
    int iresult;
    long lresult;

    asm volatile("cvttss2si %1, %0" : "=r"(iresult) : "x"(a));
    ZASSERT(iresult == 3);

    asm volatile("cvttss2si %1, %0" : "=r"(lresult) : "x"(a));
    ZASSERT(lresult == 3);

    return 0;
}
