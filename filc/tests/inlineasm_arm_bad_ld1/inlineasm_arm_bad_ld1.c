#include <stdfil.h>

int main(void)
{
    asm volatile("ld1 {v0.4s}, [x0]");
    zprintf("not reached\n");
    return 0;
}
