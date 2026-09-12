#include <stdfil.h>

int main(void)
{
    unsigned char x;
    asm volatile("inb $0x80, %0" : "=a"(x));
    return 0;
}
