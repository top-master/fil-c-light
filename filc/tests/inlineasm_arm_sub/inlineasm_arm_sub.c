#include <stdfil.h>

int main(void)
{
    /* Tied "+r" form: tied input is last, so "sub %0, %2, %1" computes x - y. */
    unsigned long x = 10;
    unsigned long y = 5;
    asm volatile("sub %0, %2, %1"
                 : "+r"(x)
                 : "r"(y));
    ZASSERT(x == 5);

    unsigned int a = 100;
    unsigned int b = 58;
    asm volatile("sub %w0, %w2, %w1"
                 : "+r"(a)
                 : "r"(b));
    ZASSERT(a == 42);

    /* Three-operand form. */
    unsigned long o1;
    asm volatile("sub %0, %1, %2"
                 : "=r"(o1)
                 : "r"(y), "r"(x));
    ZASSERT(o1 == 0); /* y - x = 5 - 5 */

    unsigned int o2;
    asm volatile("sub %w0, %w1, %w2"
                 : "=r"(o2)
                 : "r"(b), "r"(a));
    ZASSERT(o2 == 16U); /* 58 - 42 */

    /* Immediate form. */
    unsigned long o3;
    asm volatile("sub %0, %1, #1"
                 : "=r"(o3)
                 : "r"(x));
    ZASSERT(o3 == 4); /* x is 5 by now */

    /* neg / negs. */
    long n1;
    asm volatile("neg %0, %1"
                 : "=r"(n1)
                 : "r"(7L));
    ZASSERT(n1 == -7);

    int n2;
    asm volatile("neg %w0, %w1"
                 : "=r"(n2)
                 : "r"(1234));
    ZASSERT(n2 == -1234);

    unsigned long sign;
    asm volatile("negs %0, %2\n\t"
                 "cset %w1, mi"
                 : "=&r"(n1), "=r"(sign)
                 : "r"(5L)
                 : "cc");
    ZASSERT(n1 == -5);
    ZASSERT(sign == 1);

    asm volatile("negs %0, %2\n\t"
                 "cset %w1, mi"
                 : "=&r"(n1), "=r"(sign)
                 : "r"(0L)
                 : "cc");
    ZASSERT(n1 == 0);
    ZASSERT(sign == 0);

    /* subs with borrow-out via cset cc (C clear means borrow). */
    unsigned long d1;
    unsigned long borrow;
    asm volatile("subs %0, %2, %3\n\t"
                 "cset %1, cc"
                 : "=&r"(d1), "=r"(borrow)
                 : "r"(5UL), "r"(10UL)
                 : "cc");
    ZASSERT(d1 == 0xFFFFFFFFFFFFFFFBUL);
    ZASSERT(borrow == 1);

    asm volatile("subs %0, %2, %3\n\t"
                 "cset %1, cc"
                 : "=&r"(d1), "=r"(borrow)
                 : "r"(10UL), "r"(5UL)
                 : "cc");
    ZASSERT(d1 == 5);
    ZASSERT(borrow == 0);
    return 0;
}
