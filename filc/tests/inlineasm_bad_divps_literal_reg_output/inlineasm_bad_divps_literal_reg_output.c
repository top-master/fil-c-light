#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

int main(void)
{
    v4sf a = {8.0f, 6.0f, 4.0f, 2.0f};
    asm volatile("divps %%xmm1, %%xmm0" :: "x"(a));
    return 0;
}
