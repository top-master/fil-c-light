#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v4sf a = { 2.0f, 3.0f, 4.0f, 5.0f };
    v4sf b = { 1.0f, 1.0f, 1.0f, 1.0f };
    v4sf c = { 10.0f, 10.0f, 10.0f, 10.0f };

    asm volatile("vfmsubadd132ps %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    /* VFMSUBADD132PS: even elements add SRC2, odd elements subtract SRC2. */
    ZASSERT(a[0] == 21.0f);  /* 2*10 + 1 */
    ZASSERT(a[1] == 29.0f);  /* 3*10 - 1 */
    ZASSERT(a[2] == 41.0f);  /* 4*10 + 1 */
    ZASSERT(a[3] == 49.0f);  /* 5*10 - 1 */

    return 0;
}
