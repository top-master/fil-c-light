#include <stdfil.h>
#include <string.h>

/* VPDPWSSD (AVX-VNNI): accumulate dot product of signed words (src1) by
 * signed words (src2) into 32-bit destination lanes. Two words per dword.
 *   VPDPWSSD xmm1, xmm2, xmm3/m128
 */
typedef int v4si __attribute__((vector_size(16)));
typedef short v8hi __attribute__((vector_size(16)));

__attribute__((target("avx2,avxvnni"))) int main(void)
{
    short a_words[8] = {1,1, 2,2, 3,3, 4,4};
    short b_words[8] = {1,1, 1,1, 1,1, 1,1};
    v8hi a, b;
    memcpy(&a, a_words, 16);
    memcpy(&b, b_words, 16);
    v4si result = {0, 0, 0, 0};

    asm volatile("vpdpwssd %2, %1, %0" : "+x"(result) : "x"(a), "x"(b));

    int r[4];
    memcpy(r, &result, sizeof(r));
    ZASSERT(r[0] == 2);   /* 1*1 + 1*1 */
    ZASSERT(r[1] == 4);   /* 2*1 + 2*1 */
    ZASSERT(r[2] == 6);   /* 3*1 + 3*1 */
    ZASSERT(r[3] == 8);   /* 4*1 + 4*1 */

    return 0;
}
