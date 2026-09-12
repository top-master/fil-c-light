#include <stdfil.h>

int main(void)
{
    /* Leaking the values of callee-saved registers and NZCV into outputs is
       register-value disclosure, which is legal: the values are just data,
       and the asm declares every register it writes. */
    unsigned long fp;
    unsigned long lr;
    unsigned long flags;
    asm volatile("mov %0, x29" : "=r"(fp));
    asm volatile("mov %0, x30" : "=r"(lr));
    asm volatile("mrs %0, nzcv" : "=r"(flags));
    ZASSERT(fp != 0);
    ZASSERT(lr != 0);
    zprintf("leaked fp=%lu lr=%lu flags=%lu\n", fp, lr, flags);
    return 0;
}
