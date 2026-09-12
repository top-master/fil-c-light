#include <stdfil.h>

int main(void)
{
    asm volatile("getsec");
    return 0;
}
