#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4si a = { 1, 2, 3, 4 };
    v4si b = { 1, 9, 3, 9 };
    v4si r = a;
    asm volatile("pcmpeqd %1, %0" : "+x"(r) : "x"(b));
    for (int i = 0; i < 4; i++)
        ZASSERT((unsigned)r[i] == (a[i] == b[i] ? 0xffffffffu : 0x00000000u));
    return 0;
}
