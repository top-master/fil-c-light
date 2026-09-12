#include <stdfil.h>

int main(void)
{
    unsigned long x;
    unsigned long dummy;

    /* cmp $1, dummy sets CF when dummy < 1. clc clears CF. adc then adds
       the immediate, the destination, and CF. */

    /* dummy == 0: CF = 1 from cmp, then clc clears it, so adc $5, x with
       x = 10 gives 15. */
    x = 10;
    dummy = 0;
    asm volatile("cmp $1, %1\n\t"
                 "clc\n\t"
                 "adc $5, %0"
                 : "+r"(x)
                 : "r"(dummy)
                 : "cc");
    ZASSERT(x == 15);

    return 0;
}
