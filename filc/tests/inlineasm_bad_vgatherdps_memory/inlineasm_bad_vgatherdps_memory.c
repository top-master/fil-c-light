#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4sf dest = {0.0f, 0.0f, 0.0f, 0.0f};
    v4sf mask = {1.0f, 1.0f, 1.0f, 1.0f};
    v4si idx = {0, 0, 0, 0};
    unsigned long p = 0;
    asm volatile("vgatherdps %0, (%2,%3,8), %1"
                 : "+x"(dest), "+x"(mask) : "r"(p), "x"(idx));
    return 0;
}
