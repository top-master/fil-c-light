#include <stdfil.h>
#include <string.h>

typedef float v4sf __attribute__((vector_size(16)));
typedef float v8sf __attribute__((vector_size(32)));

__attribute__((target("avx"))) int main(void)
{
    /* VEXTRACTF128 (AVX): extract a 128-bit packed floating-point lane from a
       256-bit YMM source into a 128-bit XMM destination. imm8[0] selects the
       low (0) or high (1) 128-bit lane. */
    v8sf src = { 1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f };

    /* Extract the low 128-bit lane (imm8 = 0). */
    v4sf dst_lo = { 0 };
    asm volatile("vextractf128 $0, %1, %0" : "=x"(dst_lo) : "x"(src));
    ZASSERT(dst_lo[0] == 1.0f);
    ZASSERT(dst_lo[1] == 2.0f);
    ZASSERT(dst_lo[2] == 3.0f);
    ZASSERT(dst_lo[3] == 4.0f);

    /* Extract the high 128-bit lane (imm8 = 1). */
    v4sf dst_hi = { 0 };
    asm volatile("vextractf128 $1, %1, %0" : "=x"(dst_hi) : "x"(src));
    ZASSERT(dst_hi[0] == 5.0f);
    ZASSERT(dst_hi[1] == 6.0f);
    ZASSERT(dst_hi[2] == 7.0f);
    ZASSERT(dst_hi[3] == 8.0f);

    return 0;
}
