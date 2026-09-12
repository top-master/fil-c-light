#include <stdfil.h>

int main(void)
{
    asm volatile("ret");
    zprintf("not reached\n");
    return 0;
}
