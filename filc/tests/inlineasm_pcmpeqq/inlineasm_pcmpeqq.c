#include <stdfil.h>

typedef long long v2di __attribute__((vector_size(16)));

int main(void)
{
    v2di a = { 1, 2 };
    v2di b = { 1, 9 };
    v2di r = a;
    asm volatile("pcmpeqq %1, %0" : "+x"(r) : "x"(b));
    for (int i = 0; i < 2; i++)
        ZASSERT((unsigned long long)r[i] == (a[i] == b[i] ? 0xffffffffffffffffULL : 0ULL));
    return 0;
}
