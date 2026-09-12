#include <stdfil.h>

int main(void)
{
    /* hint #27 is an alias of pacibsp, which rewrites lr (x30). */
    asm volatile("hint #27");
    zprintf("not reached\n");
    return 0;
}
