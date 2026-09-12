#include <stdfil.h>

int main(void)
{
    /* hint #25 is an alias of paciasp, which rewrites lr (x30). The hint
       form declares no clobber, so it must be rejected; write "paciasp"
       with a "~{lr}" clobber instead. */
    asm volatile("hint #25");
    zprintf("not reached\n");
    return 0;
}
