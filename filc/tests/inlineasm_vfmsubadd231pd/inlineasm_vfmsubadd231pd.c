#include <stdfil.h>

typedef double v2df __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v2df a = { 2.0, 3.0 };
    v2df b = { 4.0, 5.0 };
    v2df c = { 6.0, 7.0 };

    asm volatile("vfmsubadd231pd %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    /* VFMSUBADD231PD: multiply SRC2*SRC3; even add DEST, odd subtract DEST. */
    ZASSERT(a[0] == 26.0);  /* 4*6 + 2 */
    ZASSERT(a[1] == 32.0);  /* 5*7 - 3 */

    return 0;
}
