#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = { -1, 2, -3, 4, 5, 6, 7, 8,
                9, 10, 11, 12, 13, 14, 15, 16 };
    v16qi b = { 1, 2, 3, 4, -5, 0, 7, -8,
                9, -10, 11, 12, 13, 14, -15, 16 };
    v16qi r = a;
    /* PCMPGTB: per-byte signed greater-than. dest[i] = (a[i] > b[i]) ? 0xff : 0. */
    asm volatile("pcmpgtb %1, %0" : "+x"(r) : "x"(b));
    for (int i = 0; i < 16; i++)
        ZASSERT((unsigned char)r[i] == ((signed char)a[i] > (signed char)b[i] ? 0xff : 0x00));
    return 0;
}
