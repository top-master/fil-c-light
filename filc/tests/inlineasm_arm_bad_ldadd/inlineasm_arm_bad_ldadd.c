#include <stdfil.h>

int main(void)
{
    /* LSE atomic add: an atomic read-modify-write of memory. */
    asm volatile("ldadd x1, x2, [x3]");
    zprintf("not reached\n");
    return 0;
}
