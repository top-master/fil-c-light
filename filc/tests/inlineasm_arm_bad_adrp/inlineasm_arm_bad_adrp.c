#include <stdfil.h>

int main(void)
{
    asm volatile("adrp x0, some_symbol");
    zprintf("not reached\n");
    return 0;
}
