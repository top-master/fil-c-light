#include <stdfil.h>

int main(void)
{
    asm volatile("wrpkru");
    return 0;
}
