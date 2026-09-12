#include <stdfil.h>
#include <string.h>

/* VPDPWSSDS (AVX-VNNI): like VPDPWSSD but accumulates with signed saturation
 * to 32 bits. Saturates to INT32_MIN/INT32_MAX on overflow.
 *   VPDPWSSDS xmm1, xmm2, xmm3/m128
 */
typedef int v4si __attribute__((vector_size(16)));
typedef short v8hi __attribute__((vector_size(16)));

__attribute__((target("avx2,avxvnni"))) int main(void)
{
    /* dword0: preloaded near INT32_MAX so the dot product overflows upward. */
    v4si result = {0x7ffffff0, 0, 0, 0};
    short a_words[8] = {1000, 1000, 0,0, 0,0, 0,0};
    short b_words[8] = {1000, 1000, 0,0, 0,0, 0,0};
    v8hi a, b;
    memcpy(&a, a_words, 16);
    memcpy(&b, b_words, 16);

    asm volatile("vpdpwssds %2, %1, %0" : "+x"(result) : "x"(a), "x"(b));

    int r[4];
    memcpy(r, &result, sizeof(r));
    /* dword0 overflows INT32_MAX -> saturates to 0x7fffffff. */
    ZASSERT(r[0] == 0x7fffffff);
    ZASSERT(r[1] == 0);
    ZASSERT(r[2] == 0);
    ZASSERT(r[3] == 0);

    return 0;
}
