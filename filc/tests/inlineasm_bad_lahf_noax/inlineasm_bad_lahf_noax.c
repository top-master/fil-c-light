#include <stdfil.h>

int main(void)
{
    asm volatile("lahf");
    return 0;
}
