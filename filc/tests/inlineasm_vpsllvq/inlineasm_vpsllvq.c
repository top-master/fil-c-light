#include <stdfil.h>
#include <string.h>

/* VPSLLVQ (AVX2): variable packed shift-left-logical of qwords.
 *   VPSLLVQ xmm1, xmm2, xmm3/m128
 * Each qword in src1 is shifted left by the count in the corresponding qword
 * of src2, filling with zeros.
 */
typedef long long v2di __attribute__((vector_size(16)));

__attribute__((target("avx2"))) int main(void)
{
    v2di src1 = {1, 2};
    v2di src2 = {3, 4};
    v2di dst;
    asm volatile("vpsllvq %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));

    long long r[2];
    memcpy(r, &dst, sizeof(r));
    ZASSERT(r[0] == (1LL << 3));   /* 8 */
    ZASSERT(r[1] == (2LL << 4));   /* 32 */

    /* Count >= 64 must yield zero. */
    v2di big = {63, 64};
    v2di out;
    asm volatile("vpsllvq %2, %1, %0" : "=x"(out) : "x"(src1), "x"(big));
    memcpy(r, &out, sizeof(r));
    ZASSERT(r[0] == (1LL << 63));
    ZASSERT(r[1] == 0);

    return 0;
}
