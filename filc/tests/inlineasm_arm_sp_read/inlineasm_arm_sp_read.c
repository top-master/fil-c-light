#include <stdfil.h>

int main(void)
{
    /* Reading sp is register-value disclosure: reads of arbitrary registers
       are always safe under the soundness model (the value is unobservable
       state), even though sp can never be written. */
    unsigned long o;
    asm volatile("mov %0, sp" : "=r"(o));
    ZASSERT(o != 0);
    zprintf("sp ok\n");
    return 0;
}
