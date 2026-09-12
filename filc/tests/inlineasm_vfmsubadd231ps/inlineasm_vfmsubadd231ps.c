#include <stdfil.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("fma"))) int main(void)
{
    v4sf a = { 2.0f, 3.0f, 4.0f, 5.0f };
    v4sf b = { 6.0f, 7.0f, 8.0f, 9.0f };
    v4sf c = { 10.0f, 11.0f, 12.0f, 13.0f };

    asm volatile("vfmsubadd231ps %2, %1, %0" : "+x"(a) : "x"(b), "x"(c));

    /* VFMSUBADD231PS: multiply SRC2*SRC3; even add DEST, odd subtract DEST. */
    ZASSERT(a[0] == 62.0f);   /* 6*10 + 2 */
    ZASSERT(a[1] == 74.0f);   /* 7*11 - 3 */
    ZASSERT(a[2] == 100.0f);  /* 8*12 + 4 */
    ZASSERT(a[3] == 112.0f);  /* 9*13 - 5 */

    return 0;
}
