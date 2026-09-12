#include <stdfil.h>

int main(void)
{
    /* Tied "+r" form (tied input is the last operand in the IR), x width. */
    unsigned long x = 10;
    unsigned long y = 5;
    asm volatile("add %0, %1, %2"
                 : "+r"(x)
                 : "r"(y));
    ZASSERT(x == 15);

    /* Tied "+r" form, w width. */
    unsigned int a = 100;
    unsigned int b = 58;
    asm volatile("add %w0, %w1, %w2"
                 : "+r"(a)
                 : "r"(b));
    ZASSERT(a == 158);

    /* Plain three-operand register form. */
    unsigned long o1;
    asm volatile("add %0, %1, %2"
                 : "=r"(o1)
                 : "r"(x), "r"(y));
    ZASSERT(o1 == 20);

    unsigned int o2;
    asm volatile("add %w0, %w1, %w2"
                 : "=r"(o2)
                 : "r"(a), "r"(b));
    ZASSERT(o2 == 216);

    /* Immediate forms. */
    unsigned long o3;
    asm volatile("add %0, %1, #1000"
                 : "=r"(o3)
                 : "r"(x));
    ZASSERT(o3 == 1015); /* x is 15 by now */

    unsigned int o4;
    asm volatile("add %w0, %w1, #1"
                 : "=r"(o4)
                 : "r"(a));
    ZASSERT(o4 == 159); /* a is 158 by now */

    unsigned long o5;
    asm volatile("add %0, %1, #0x400"
                 : "=r"(o5)
                 : "r"(y));
    ZASSERT(o5 == 1029);

    /* Multiple adds in one string. */
    unsigned long o6;
    asm volatile("add %0, %1, #16\n\tadd %0, %0, #32"
                 : "=&r"(o6)
                 : "r"(x));
    ZASSERT(o6 == 63); /* x is 15 by now */
    return 0;
}
