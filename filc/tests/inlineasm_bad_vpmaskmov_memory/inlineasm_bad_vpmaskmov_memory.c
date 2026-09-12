#include <stdfil.h>

typedef int v4si __attribute__((vector_size(16)));

int main(void)
{
    v4si mask = {0, 0, 0, 0};
    v4si dst;
    unsigned long p = 0;
    /* VPMASKMOV always requires a memory operand (conditional load/store).
       There is no register-only form, so it cannot be made safe. */
    asm volatile("vpmaskmovd %0, %1, (%2)" : "=x"(dst) : "x"(mask), "r"(p));
    return 0;
}
