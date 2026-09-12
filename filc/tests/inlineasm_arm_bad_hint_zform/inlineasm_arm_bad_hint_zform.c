#include <stdfil.h>

int main(void)
{
    /* hint #26 is an alias of paciaz: the zero-modifier pointer
       authentication form that rewrites lr (x30). */
    asm volatile("hint #26");
    zprintf("not reached\n");
    return 0;
}
