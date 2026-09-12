#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v2df dest = {0.0, 0.0};
    v2df mask = {1.0, 1.0};
    v4si idx = {0, 0, 0, 0};
    unsigned long p = 0;
    asm volatile("vgatherdpd %0, (%2,%3,8), %1"
                 : "+x"(dest), "+x"(mask) : "r"(p), "x"(idx));
    return 0;
}
