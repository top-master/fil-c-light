#include <stdfil.h>
#include <string.h>

/* VPSRAVD (AVX2): variable packed shift-right-arithmetic of dwords.
 *   VPSRAVD xmm1, xmm2, xmm3/m128
 * Each dword in src1 is shifted right arithmetically (sign-extending) by the
 * count in the corresponding dword of src2.
 */
typedef int v4si __attribute__((vector_size(16)));

__attribute__((target("avx2"))) int main(void)
{
    v4si src1 = {-16, 16, -8, 8};
    v4si src2 = {2, 2, 1, 1};
    v4si dst;
    asm volatile("vpsravd %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));

    int r[4];
    memcpy(r, &dst, sizeof(r));
    ZASSERT(r[0] == (-16 >> 2));  /* -4 */
    ZASSERT(r[1] == (16 >> 2));   /* 4 */
    ZASSERT(r[2] == (-8 >> 1));   /* -4 */
    ZASSERT(r[3] == (8 >> 1));    /* 4 */

    /* Count >= 32 must saturate: all-sign-bits (negative src) or zero
     * (positive src), per the arithmetic-shift rule. */
    v4si big = {31, 32, 33, 0};
    v4si out;
    asm volatile("vpsravd %2, %1, %0" : "=x"(out) : "x"(src1), "x"(big));
    memcpy(r, &out, sizeof(r));
    ZASSERT(r[0] == (-16 >> 31));  /* -1 */
    ZASSERT(r[1] == 0);            /* positive src, count>=32 -> 0 */
    ZASSERT(r[2] == -1);           /* negative src, count>=32 -> -1 */
    ZASSERT(r[3] == 8);

    return 0;
}
