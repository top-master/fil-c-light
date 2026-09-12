#include <stdfil.h>

int main(void)
{
    asm volatile("fclex" : : : "fpsr");
    asm volatile("fnclex" : : : "fpsr");
    return 0;
}
