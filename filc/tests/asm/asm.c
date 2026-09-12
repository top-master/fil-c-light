#include <stdfil.h>

int main(void)
{
    zprintf("Yesyes\n");
    asm volatile("nop" : : : "memory");
    zprintf("Nono\n");
    return 0;
}

