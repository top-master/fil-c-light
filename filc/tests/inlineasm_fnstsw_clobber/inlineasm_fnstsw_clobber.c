#include <stdfil.h>

int main(void)
{
    asm volatile("fnstsw %%ax" : : : "ax", "fpsr");
    return 0;
}
