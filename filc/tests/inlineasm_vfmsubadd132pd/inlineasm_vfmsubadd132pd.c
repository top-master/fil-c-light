#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v2df a = { 2.0, 3.0 };
    v2df b = { 1.0, 1.0 };
    v2df c = { 10.0, 10.0 };

    asm volatile("vfmsubadd132pd %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    /* VFMSUBADD132PD: even elements add SRC2, odd elements subtract SRC2. */
    ZASSERT(a[0] == 21.0);  /* 2*10 + 1 */
    ZASSERT(a[1] == 29.0);  /* 3*10 - 1 */

    return 0;
}
