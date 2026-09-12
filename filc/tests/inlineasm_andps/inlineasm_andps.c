#include <stdfil.h>

typedef unsigned long long v2du __attribute__((vector_size(16)));

int main(void)
{
    v2du a = { 0xFFFFFFFFFFFFFFFFULL, 0xAAAAAAAAAAAAAAAAULL };
    v2du b = { 0x0F0F0F0F0F0F0F0FULL, 0x5555555555555555ULL };

    asm volatile("andps %1, %0" : "+x"(a) : "x"(b));

    ZASSERT(a[0] == 0x0F0F0F0F0F0F0F0FULL);
    ZASSERT(a[1] == 0);

    return 0;
}
