#include <stdfil.h>
#include <string.h>

/* VPSRLVD (AVX2): variable packed shift-right-logical of dwords.
 *   VPSRLVD xmm1, xmm2, xmm3/m128
 * Each dword in src1 is shifted right logically (zero-filled) by the count in
 * the corresponding dword of src2.
 */
typedef unsigned v4su __attribute__((vector_size(16)));

__attribute__((target("avx2"))) int main(void)
{
    v4su src1 = {0x80000000u, 0x80000000u, 0xFFFFFFFFu, 0xFFFFFFFFu};
    v4su src2 = {1, 4, 1, 4};
    v4su dst;
    asm volatile("vpsrlvd %2, %1, %0" : "=x"(dst) : "x"(src1), "x"(src2));

    unsigned r[4];
    memcpy(r, &dst, sizeof(r));
    ZASSERT(r[0] == 0x40000000u);
    ZASSERT(r[1] == 0x08000000u);
    ZASSERT(r[2] == 0x7FFFFFFFu);
    ZASSERT(r[3] == 0x0FFFFFFFu);

    /* Count >= 32 must yield zero. */
    v4su big = {31, 32, 33, 0};
    v4su out;
    asm volatile("vpsrlvd %2, %1, %0" : "=x"(out) : "x"(src1), "x"(big));
    memcpy(r, &out, sizeof(r));
    ZASSERT(r[0] == 0x00000001u);
    ZASSERT(r[1] == 0);
    ZASSERT(r[2] == 0);
    ZASSERT(r[3] == 0xFFFFFFFFu);

    return 0;
}
