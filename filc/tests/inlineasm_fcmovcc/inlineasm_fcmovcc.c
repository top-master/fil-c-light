#include <stdfil.h>

int main(void)
{
    double a = 1.0;
    double b = 2.0;
    int cond = 0;
    asm volatile(
        "cmp $1, %2\n\t"
        "fcmovb %1, %0"
        : "+t"(a)
        : "u"(b), "r"(cond)
        : "cc"
    );
    ZASSERT(a == 2.0);

    a = 1.0;
    cond = 2;
    asm volatile(
        "cmp $1, %2\n\t"
        "fcmovb %1, %0"
        : "+t"(a)
        : "u"(b), "r"(cond)
        : "cc"
    );
    ZASSERT(a == 1.0);

    return 0;
}
