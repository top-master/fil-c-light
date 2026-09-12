#include <stdfil.h>

int main(void)
{
    asm volatile("wbnoinvd");
    return 0;
}
