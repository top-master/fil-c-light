#include <stdfil.h>

int main(void)
{
    asm volatile("wrmsr");
    return 0;
}
