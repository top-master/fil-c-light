#include <stdfil.h>

int main(void)
{
    /* Register variables bound to fixed registers as operands. */
    register long a asm("x8") = 40;
    register long b asm("x9") = 2;
    long r;
    asm volatile("add %0, %1, %2"
                 : "=r"(r)
                 : "r"(a), "r"(b));
    ZASSERT(r == 42);

    register long c asm("x10") = 21;
    register long d asm("x11") = 2;
    asm volatile("mul %0, %1, %2"
                 : "=r"(r)
                 : "r"(c), "r"(d));
    ZASSERT(r == 42);

    register long e asm("x12") = 50;
    register long f asm("x13") = 8;
    asm volatile("sub %0, %1, %2"
                 : "=r"(r)
                 : "r"(e), "r"(f));
    ZASSERT(r == 42);

    /* A register variable used as an output. */
    register long o asm("x14");
    asm volatile("add %0, %1, %1"
                 : "=r"(o)
                 : "r"(a));
    ZASSERT(o == 80);

    /* Clobber style: the asm uses x8 as scratch; the compiler must
       preserve the value living in the register variable. */
    register long kept asm("x8") = 12345;
    long out;
    asm volatile("mov x8, #999\n\t"
                 "add %0, x8, %1"
                 : "=r"(out)
                 : "r"(1L)
                 : "x8");
    ZASSERT(kept == 12345);
    ZASSERT(out == 1000);

    /* Two register variables survive a clobbering asm. */
    register long k1 asm("x9") = 111;
    register long k2 asm("x10") = 222;
    long o2;
    asm volatile("mov x9, #1\n\t"
                 "mov x10, #2\n\t"
                 "add %0, x9, x10"
                 : "=r"(o2)
                 :
                 : "x9", "x10");
    ZASSERT(k1 == 111 && k2 == 222);
    ZASSERT(o2 == 3);
    return 0;
}
