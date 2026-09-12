#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));

int main(void)
{
    v8hi a = { 1, 2, 3, 4, 5, 6, 7, 8 };
    v8hi b = { 1, 9, 3, 9, 5, 9, 7, 9 };
    v8hi r = a;
    asm volatile("pcmpeqw %1, %0" : "+x"(r) : "x"(b));
    for (int i = 0; i < 8; i++)
        ZASSERT((unsigned short)r[i] == (a[i] == b[i] ? 0xffff : 0x0000));
    return 0;
}
