#include <stdfil.h>

int main(void)
{
    /* hint #29 is an alias of autiasp, which rewrites lr (x30). */
    asm volatile("hint #29");
    zprintf("not reached\n");
    return 0;
}
