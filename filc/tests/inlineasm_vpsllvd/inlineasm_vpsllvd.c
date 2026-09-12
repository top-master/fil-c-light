#include <stdfil.h>
#include <string.h>

/* VPSLLVD (AVX2): variable packed shift-left-logical of dwords.
 *   VPSLLVD xmm1, xmm2, xmm3/m128
 * Each dword in src1 is shifted left by the count in the corresponding dword
 * of src2, filling with zeros.
 */
typedef int v4si __attribute__((vector_size(16)));

__attribute__((target("avx2"))) int main(void)
{
    v4si src1 = {1, 2, 3, 4};
    v4si src2 = {1, 2, 3, 4};
    v4si dst;
    asm volatile("vpsllvd %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));

    int r[4];
    memcpy(r, &dst, sizeof(r));
    ZASSERT(r[0] == (1 << 1));   /* 2 */
    ZASSERT(r[1] == (2 << 2));   /* 8 */
    ZASSERT(r[2] == (3 << 3));   /* 24 */
    ZASSERT(r[3] == (4 << 4));   /* 64 */

    /* Large count (>=32) must yield zero. */
    v4si big = {31, 32, 33, 0};
    v4si out;
    asm volatile("vpsllvd %2, %1, %0" : "=x"(out) : "x"(src1), "x"(big));
    memcpy(r, &out, sizeof(r));
    ZASSERT(r[0] == (1 << 31));
    ZASSERT(r[1] == 0);
    ZASSERT(r[2] == 0);
    ZASSERT(r[3] == 4);

    return 0;
}
