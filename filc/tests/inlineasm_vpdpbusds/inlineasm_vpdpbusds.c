#include <stdfil.h>
#include <string.h>

/* VPDPBUSDS (AVX-VNNI): like VPDPBUSD but accumulates with signed saturation
 * to 32 bits. Saturates to INT32_MIN/INT32_MAX on overflow.
 *   VPDPBUSDS xmm1, xmm2, xmm3/m128
 */
typedef int v4si __attribute__((vector_size(16)));
typedef unsigned char v16qu __attribute__((vector_size(16)));

__attribute__((target("avx2,avxvnni"))) int main(void)
{
    /* dword0: preloaded near INT32_MAX so the dot product overflows upward. */
    v4si result = {0x7ffffff0, 0, 0, 0};
    unsigned char a_bytes[16] = {255,255,255,255, 1,1,1,1, 0,0,0,0, 0,0,0,0};
    signed char b_bytes[16]   = {127,127,127,127, 1,1,1,1, 0,0,0,0, 0,0,0,0};
    v16qu a, b;
    memcpy(&a, a_bytes, 16);
    memcpy(&b, b_bytes, 16);

    asm volatile("vpdpbusds %2, %1, %0" : "+x"(result) : "x"(a), "x"(b));

    int r[4];
    memcpy(r, &result, sizeof(r));
    /* dword0 overflows INT32_MAX -> saturates to 0x7fffffff. */
    ZASSERT(r[0] == 0x7fffffff);
    /* dword1: 4 * (1*1) = 4, no overflow. */
    ZASSERT(r[1] == 4);
    ZASSERT(r[2] == 0);
    ZASSERT(r[3] == 0);

    return 0;
}
