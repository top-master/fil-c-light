#include <stdfil.h>

int main(void)
{
    float a = 3.0f;
    long result;

    asm volatile("cvtss2si %1, %0" : "=r"(result) : "x"(a));

    ZASSERT(result == 3);

    return 0;
}
