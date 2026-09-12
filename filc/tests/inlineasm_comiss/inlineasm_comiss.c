#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = { 1.0f, 2.0f, 3.0f, 4.0f };
    v4sf b = { 1.0f, 3.0f, 5.0f, 7.0f };

    asm volatile("comiss %1, %0" :: "x"(a), "x"(b) : "cc");

    return 0;
}
