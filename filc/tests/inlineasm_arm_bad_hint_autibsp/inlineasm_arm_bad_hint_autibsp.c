#include <stdfil.h>

int main(void)
{
    /* hint #31 is an alias of autibsp, which rewrites lr (x30). */
    asm volatile("hint #31");
    zprintf("not reached\n");
    return 0;
}
