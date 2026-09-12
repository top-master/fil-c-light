#include <stdfil.h>

typedef short v8hi __attribute__((vector_size(16)));

int main(void)
{
    v8hi a = { 10, 20, 30, 40, 50, 60, 70, 80 };
    v8hi b = { 20, 30, 40, 50, 60, 70, 80, 90 };
    v8hi r = a;
    asm volatile("pavgw %1, %0" : "+x"(r) : "x"(b));
    for (int i = 0; i < 8; i++)
        ZASSERT((unsigned short)r[i] == (unsigned short)(((unsigned short)a[i] + (unsigned short)b[i] + 1) >> 1));
    return 0;
}
