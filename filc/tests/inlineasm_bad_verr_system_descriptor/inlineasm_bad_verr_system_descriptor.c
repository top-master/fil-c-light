#include <stdfil.h>

int main(void)
{
    asm volatile("verr %%ax" ::: "cc");
    return 0;
}
