#include <stdfil.h>

int main(void)
{
    asm volatile("svc #0");
    zprintf("not reached\n");
    return 0;
}
