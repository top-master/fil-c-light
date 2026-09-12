#include <stdfil.h>

int main(void)
{
    int a = 1;
    int b = 2;
    int c = 0;

    asm volatile("dmb ish" ::: "memory");
    c = a + b;
    asm volatile("dmb ishld" ::: "memory");
    ZASSERT(c == 3);

    asm volatile("dmb ishst" ::: "memory");
    asm volatile("dmb sy" ::: "memory");
    asm volatile("dmb ld" ::: "memory");
    asm volatile("dmb st" ::: "memory");
    asm volatile("dmb oshld" ::: "memory");
    asm volatile("dmb nsh" ::: "memory");

    asm volatile("dsb sy" ::: "memory");
    asm volatile("dsb ish" ::: "memory");
    asm volatile("dsb ishst" ::: "memory");
    asm volatile("dsb osh" ::: "memory");

    asm volatile("isb" ::: "memory");
    asm volatile("isb sy" ::: "memory");

    /* A sequence with fences in the middle still computes correctly. */
    unsigned long acc = 0;
    for (int i = 1; i <= 10; ++i) {
        asm volatile("dmb ish" ::: "memory");
        acc += (unsigned long)i;
    }
    ZASSERT(acc == 55);
    return 0;
}
