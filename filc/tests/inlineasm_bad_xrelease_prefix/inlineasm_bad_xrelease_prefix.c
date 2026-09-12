#include <stdfil.h>

int main(void)
{
    asm volatile("xrelease");
    return 0;
}
