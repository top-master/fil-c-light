#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));
typedef long long v2di __attribute__((vector_size(16)));

int main(void)
{
    v2df dest = {0.0, 0.0};
    v2df mask = {1.0, 1.0};
    v2di idx = {0, 0};
    unsigned long p = 0;
    asm volatile("vgatherqpd %0, (%2,%3,8), %1"
                 : "+x"(dest), "+x"(mask) : "r"(p), "x"(idx));
    return 0;
}
