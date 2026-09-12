#include <stdfil.h>
#include <string.h>

/* VPSRLVQ (AVX2): variable packed shift-right-logical of qwords.
 *   VPSRLVQ xmm1, xmm2, xmm3/m128
 * Each qword in src1 is shifted right logically (zero-filled) by the count in
 * the corresponding qword of src2.
 */
typedef unsigned long long v2du __attribute__((vector_size(16)));

__attribute__((target("avx2"))) int main(void)
{
    v2du src1 = {0x8000000000000000ULL, 0xFFFFFFFFFFFFFFFFULL};
    v2du src2 = {4, 8};
    v2du dst;
    asm volatile("vpsrlvq %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));

    unsigned long long r[2];
    memcpy(r, &dst, sizeof(r));
    ZASSERT(r[0] == 0x0800000000000000ULL);
    ZASSERT(r[1] == 0x00FFFFFFFFFFFFFFULL);

    /* Count >= 64 must yield zero. */
    v2du big = {63, 64};
    v2du out;
    asm volatile("vpsrlvq %2, %1, %0" : "=x"(out) : "x"(src1), "x"(big));
    memcpy(r, &out, sizeof(r));
    ZASSERT(r[0] == 0x0000000000000001ULL);
    ZASSERT(r[1] == 0);

    return 0;
}
