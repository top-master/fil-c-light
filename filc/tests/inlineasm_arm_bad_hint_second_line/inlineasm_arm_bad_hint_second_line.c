#include <stdfil.h>

int main(void)
{
    /* Validation is per-line: a dangerous hint must be caught even when it
       is not the first line of the asm string. (Second line is hint #25 =
       paciasp, which rewrites lr.) */
    asm volatile("nop\n\thint #25");
    zprintf("not reached\n");
    return 0;
}
