#include <stdfil.h>

typedef unsigned int v4si __attribute__((vector_size(16)));

int main(void)
{
    /* XORPS dest, src: dest = dest ^ src. AT&T: xorps src, dest. No flags. */
    v4si a = { 0xFF00FF00, 0x00FF00FF, 0x12345678, 0x9ABCDEF0 };
    v4si b = { 0x0F0F0F0F, 0xF0F0F0F0, 0xFFFFFFFF, 0x00000000 };
    asm volatile("xorps %1, %0" : "+x"(a) : "x"(b));
    ZASSERT(a[0] == (unsigned)(0xFF00FF00 ^ 0x0F0F0F0F));
    ZASSERT(a[1] == (unsigned)(0x00FF00FF ^ 0xF0F0F0F0));
    ZASSERT(a[2] == (unsigned)(0x12345678 ^ 0xFFFFFFFF));
    ZASSERT(a[3] == (unsigned)(0x9ABCDEF0 ^ 0x00000000));
    return 0;
}
