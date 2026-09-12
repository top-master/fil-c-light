#include <stdfil.h>

int main(void)
{
    unsigned short ax = 0xFF00;
    asm volatile("sahf" : : "a"(ax));
    return 0;
}
