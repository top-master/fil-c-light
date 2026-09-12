#include <stdfil.h>

int main(void)
{
    asm volatile("wbinvd");
    return 0;
}
