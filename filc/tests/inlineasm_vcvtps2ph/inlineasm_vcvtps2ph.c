#include <stdfil.h>
#include <string.h>

typedef float v4sf __attribute__((vector_size(16)));

__attribute__((target("f16c"))) int main(void)
{
    v4sf src = { 1.0f, 2.0f, 0.5f, 3.0f };

    /* VCVTPS2PH (F16C, 128-bit): convert 4 packed single-precision FP values
       in the source XMM register to 4 packed FP16 values in the low 64 bits
       of the destination XMM register. The imm8 selects the rounding mode
       (0 = round to nearest even, using the immediate RC bits). */
    v4sf dst = { 0 };
    asm volatile("vcvtps2ph $0, %1, %0" : "=x"(dst) : "x"(src));

    unsigned short fp16[4];
    memcpy(fp16, &dst, 8);

    ZASSERT(fp16[0] == 0x3C00);  /* 1.0 */
    ZASSERT(fp16[1] == 0x4000);  /* 2.0 */
    ZASSERT(fp16[2] == 0x3800);  /* 0.5 */
    ZASSERT(fp16[3] == 0x4200);  /* 3.0 */

    return 0;
}
