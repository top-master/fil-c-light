#include <stdfil.h>
#include <string.h>

/* VPDPBUSD (AVX-VNNI): accumulate dot product of unsigned bytes (src1) by
 * signed bytes (src2) into 32-bit destination lanes.
 *   VPDPBUSD xmm1, xmm2, xmm3/m128
 *   xmm1 += sum( xmm2.ub[i] * xmm3.sb[i] ) per dword group of 4 bytes.
 */
typedef int v4si __attribute__((vector_size(16)));
typedef unsigned char v16qu __attribute__((vector_size(16)));

__attribute__((target("avx2,avxvnni"))) int main(void)
{
    unsigned char a_bytes[16] = {1,1,1,1, 2,2,2,2, 3,3,3,3, 4,4,4,4};
    unsigned char b_bytes[16] = {1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1};
    v16qu a, b;
    memcpy(&a, a_bytes, 16);
    memcpy(&b, b_bytes, 16);
    v4si result = {0, 0, 0, 0};

    asm volatile("vpdpbusd %2, %1, %0" : "+x"(result) : "x"(a), "x"(b));

    int r[4];
    memcpy(r, &result, sizeof(r));
    ZASSERT(r[0] == 4);   /* 4 * (1*1) */
    ZASSERT(r[1] == 8);   /* 4 * (2*1) */
    ZASSERT(r[2] == 12);  /* 4 * (3*1) */
    ZASSERT(r[3] == 16);  /* 4 * (4*1) */

    /* Accumulate again to confirm read-modify-write semantics. */
    asm volatile("vpdpbusd %2, %1, %0" : "+x"(result) : "x"(a), "x"(b));
    memcpy(r, &result, sizeof(r));
    ZASSERT(r[0] == 8);
    ZASSERT(r[1] == 16);
    ZASSERT(r[2] == 24);
    ZASSERT(r[3] == 32);

    return 0;
}
