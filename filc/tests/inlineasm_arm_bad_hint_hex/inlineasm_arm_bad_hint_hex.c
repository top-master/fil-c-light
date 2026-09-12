#include <stdfil.h>

int main(void)
{
    /* Hex spellings must be parsed, not just decimal: 0x19 is 25, i.e. an
       alias of paciasp, which rewrites lr (x30). */
    asm volatile("hint #0x19");
    zprintf("not reached\n");
    return 0;
}
