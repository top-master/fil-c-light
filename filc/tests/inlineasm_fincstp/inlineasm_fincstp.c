#include <stdfil.h>

int main(void)
{
    asm volatile("fincstp" : : : "fpsr");
    return 0;
}
