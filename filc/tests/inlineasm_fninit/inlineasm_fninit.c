#include <stdfil.h>

int main(void)
{
    asm volatile("fninit" : : : "fpsr");
    return 0;
}
