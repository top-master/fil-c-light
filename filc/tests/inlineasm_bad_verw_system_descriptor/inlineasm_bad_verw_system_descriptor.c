#include <stdfil.h>

int main(void)
{
    asm volatile("verw %%ax" ::: "cc");
    return 0;
}
