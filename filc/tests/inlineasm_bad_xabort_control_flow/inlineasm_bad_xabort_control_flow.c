#include <stdfil.h>

int main(void)
{
    asm volatile("xabort $0");
    return 0;
}
