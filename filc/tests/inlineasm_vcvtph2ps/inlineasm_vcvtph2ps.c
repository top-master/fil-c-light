#include <stdfil.h>
#include <string.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("f16c"))) int main(void)
{
    /* FP16 (IEEE 754 half) bit patterns for: 1.0, 2.0, 0.5, 3.0 */
    unsigned short fp16[4] = { 0x3C00, 0x4000, 0x3800, 0x4200 };

    v4sf src = { 0 };
    memcpy(&src, fp16, 8);

    /* VCVTPH2PS (F16C, 128-bit): convert 4 packed FP16 values in the low
       64 bits of the source XMM register to 4 packed single-precision FP
       values in the destination XMM register. */
    v4sf dst;
    asm volatile("vcvtph2ps %1, %0" : "=x"(dst) : "x"(src));

    ZASSERT(dst[0] == 1.0f);
    ZASSERT(dst[1] == 2.0f);
    ZASSERT(dst[2] == 0.5f);
    ZASSERT(dst[3] == 3.0f);

    return 0;
}
