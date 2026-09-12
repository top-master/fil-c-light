#include <stdfil.h>
#include <string.h>

typedef long long v2di __attribute__((vector_size(16)));
typedef long long v4di __attribute__((vector_size(32)));

__attribute__((target("avx2"))) int main(void)
{
    /* VEXTRACTI128 (AVX2): extract a 128-bit packed integer lane from a
       256-bit YMM source into a 128-bit XMM destination. imm8[0] selects the
       low (0) or high (1) 128-bit lane. */
    v4di src = { 10, 20, 30, 40 };

    /* Extract the low 128-bit lane (imm8 = 0). */
    v2di dst_lo = { 0 };
    asm volatile("vextracti128 $0, %1, %0" : "=x"(dst_lo) : "x"(src));
    ZASSERT(dst_lo[0] == 10);
    ZASSERT(dst_lo[1] == 20);

    /* Extract the high 128-bit lane (imm8 = 1). */
    v2di dst_hi = { 0 };
    asm volatile("vextracti128 $1, %1, %0" : "=x"(dst_hi) : "x"(src));
    ZASSERT(dst_hi[0] == 30);
    ZASSERT(dst_hi[1] == 40);

    return 0;
}
