#include <stdfil.h>

int main(void)
{
    void* q;
    asm volatile("mov %0, x1"
                 : "=r"(q));
    zprintf("not reached\n");
    return 0;
}
