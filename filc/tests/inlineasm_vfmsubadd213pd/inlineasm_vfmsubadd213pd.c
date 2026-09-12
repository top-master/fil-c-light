#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v2df a = { 2.0, 3.0 };
    v2df b = { 4.0, 5.0 };
    v2df c = { 6.0, 7.0 };

    asm volatile("vfmsubadd213pd %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    /* VFMSUBADD213PD: multiply SRC2*DEST; even add SRC3, odd subtract SRC3. */
    ZASSERT(a[0] == 14.0);  /* 4*2 + 6 */
    ZASSERT(a[1] == 8.0);   /* 5*3 - 7 */

    return 0;
}
