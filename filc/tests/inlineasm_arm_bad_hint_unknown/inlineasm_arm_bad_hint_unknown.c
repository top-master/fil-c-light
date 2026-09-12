#include <stdfil.h>

int main(void)
{
    /* hint #50 is unallocated. Unallocated hints currently behave as nops,
       but only a fixed allowlist of hint numbers is accepted, since future
       architecture revisions may allocate them to instructions that write
       registers (like hint #25-#31 already do). */
    asm volatile("hint #50");
    zprintf("not reached\n");
    return 0;
}
