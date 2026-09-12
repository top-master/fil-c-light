#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

int main(void)
{
    v2df a = { 1.0, 2.0 };
    v2df b = { 1.0, 3.0 };

    asm volatile("comisd %1, %0" :: "x"(a), "x"(b) : "cc");

    return 0;
}
