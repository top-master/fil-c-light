#include <stdfil.h>

int main(void)
{
    /* LSE compare and swap: an atomic read-modify-write of memory. */
    asm volatile("cas x1, x2, [x3]");
    zprintf("not reached\n");
    return 0;
}
