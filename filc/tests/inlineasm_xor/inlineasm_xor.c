#include <stdfil.h>

int main(void)
{
    /* XOR dest, src: dest = dest ^ src. AT&T: xor src, dest.
       Sets arithmetic flags. */
    unsigned long a = 0xFF00, b = 0x0FF0;
    asm volatile("xor %1, %0" : "+r"(a) : "r"(b) : "cc");
    ZASSERT(a == 0xF0F0);
    return 0;
}
