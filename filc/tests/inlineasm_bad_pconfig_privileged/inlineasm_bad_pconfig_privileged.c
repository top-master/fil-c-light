#include <stdfil.h>

int main(void)
{
    /* PCONFIG is a privileged platform-configuration instruction (requires
       CPL=0, else #UD). It reads a 192-byte structure from memory (DS:RBX)
       and programs the platform's total-memory-encryption multi-key (TME-MK)
       key table, which is shared across all logical processors. It is not
       safe for inline asm: it is privileged, accesses memory, and has
       system-wide side effects beyond modifying registers. FilPizlonator
       must reject it. */
    asm volatile("pconfig");
    return 0;
}
