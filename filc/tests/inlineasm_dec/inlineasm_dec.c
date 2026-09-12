#include <stdfil.h>

int main(void)
{
    unsigned long x;

    x = 10;
    asm volatile("decq %0"
                 : "+r"(x)
                 :
                 : "cc");
    ZASSERT(x == 9);

    x = 0;
    asm volatile("decq %0"
                 : "+r"(x)
                 :
                 : "cc");
    ZASSERT(x == -1ul);

    unsigned int y;

    y = 10;
    asm volatile("decl %0"
                 : "+r"(y)
                 :
                 : "cc");
    ZASSERT(y == 9);

    y = 0;
    asm volatile("decl %0"
                 : "+r"(y)
                 :
                 : "cc");
    ZASSERT(y == 0xffffffffu);

    unsigned short z;

    z = 10;
    asm volatile("decw %0"
                 : "+r"(z)
                 :
                 : "cc");
    ZASSERT(z == 9);

    z = 0;
    asm volatile("decw %0"
                 : "+r"(z)
                 :
                 : "cc");
    ZASSERT(z == 0xffff);

    unsigned char w;

    w = 10;
    asm volatile("decb %0"
                 : "+r"(w)
                 :
                 : "cc");
    ZASSERT(w == 9);

    w = 0;
    asm volatile("decb %0"
                 : "+r"(w)
                 :
                 : "cc");
    ZASSERT(w == 0xff);

    return 0;
}
