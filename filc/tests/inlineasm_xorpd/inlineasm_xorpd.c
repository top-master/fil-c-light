#include <stdfil.h>

typedef unsigned long long v2di __attribute__((vector_size(16)));

int main(void)
{
    /* XORPD dest, src: dest = dest ^ src. AT&T: xorpd src, dest. No flags. */
    v2di a = { 0xFF00FF00FF00FF00ULL, 0x00FF00FF00FF00FFULL };
    v2di b = { 0x0F0F0F0F0F0F0F0FULL, 0xF0F0F0F0F0F0F0F0ULL };
    asm volatile("xorpd %1, %0" : "+x"(a) : "x"(b));
    ZASSERT(a[0] == (0xFF00FF00FF00FF00ULL ^ 0x0F0F0F0F0F0F0F0FULL));
    ZASSERT(a[1] == (0x00FF00FF00FF00FFULL ^ 0xF0F0F0F0F0F0F0F0ULL));
    return 0;
}
