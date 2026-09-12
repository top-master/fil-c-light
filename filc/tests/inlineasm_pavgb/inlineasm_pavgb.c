#include <stdfil.h>

typedef char v16qi __attribute__((vector_size(16)));

int main(void)
{
    v16qi a = { 10, 20, 30, 40, 50, 60, 70, 80,
                90, 100, 110, 120, 130, 140, 150, 200 };
    v16qi b = { 20, 30, 40, 50, 60, 70, 80, 90,
                100, 110, 120, 130, 140, 150, 200, 10 };
    v16qi r = a;
    asm volatile("pavgb %1, %0" : "+x"(r) : "x"(b));
    for (int i = 0; i < 16; i++)
        ZASSERT((unsigned char)r[i] == (unsigned char)(((unsigned char)a[i] + (unsigned char)b[i] + 1) >> 1));
    return 0;
}
