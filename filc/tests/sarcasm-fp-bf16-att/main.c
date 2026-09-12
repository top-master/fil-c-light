#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

void bf16cvt(void* in, void* out);

/* C round-to-nearest-even float->bf16 reference (cross-checked against
   hardware, including tie cases and the overflow-to-inf boundary). */
static uint16_t f2bf16_rne(float f)
{
    uint32_t x;
    memcpy(&x, &f, 4);
    uint32_t lsb = (x >> 16) & 1;
    x += 0x7FFF + lsb;
    return (uint16_t)(x >> 16);
}

int main()
{
    float* in = malloc(192);       /* [0,16) cvtneps2bf16 src, [16,32) ne2 src1, [32,48) ne2 src2 */
    uint16_t* out = malloc(96);
    if (!in || !out)
        return 1;

    /* exactly-representable values, ties, and rounding-boundary cases */
    static const uint32_t bits[16] = {
        0x3F800000,   /* 1.0 */
        0x40000000,   /* 2.0 */
        0x40600000,   /* 3.5 */
        0xC0880000,   /* -4.25 */
        0x42C80000,   /* 100.0 */
        0x3F000000,   /* 0.5 */
        0xBFC00000,   /* -1.5 */
        0x00000000,   /* 0.0 */
        0x80000000,   /* -0.0 */
        0x44800000,   /* 1024.0 */
        0x3E800000,   /* 0.25 */
        0x40490FDB,   /* pi (rounds down) */
        0x3FC08000,   /* tie: rounds to even 0x3FC0 */
        0x3FC18000,   /* tie: rounds to even 0x3FC2 */
        0x7F7FFFFF,   /* max float: rounds up to bf16 inf 0x7F80 */
        0x00800000    /* min normal float */
    };
    int i;
    for (i = 0; i < 16; i++)
        memcpy(&in[i], &bits[i], 4);
    for (i = 0; i < 16; i++)
        in[16 + i] = (float)(i + 1);        /* 1..16 */
    for (i = 0; i < 16; i++)
        in[32 + i] = (float)(100 + i);      /* 100..115 */

    bf16cvt(in, out);

    /* vcvtneps2bf16 results */
    for (i = 0; i < 16; i++) {
        uint16_t e = f2bf16_rne(in[i]);
        if (out[i] != e) {
            printf("neps2bf16[%d]: got %04x want %04x\n", i, out[i], e);
            return 1;
        }
    }
    /* vcvtne2ps2bf16: dest low half = memory source (src2), high = src1 */
    for (i = 0; i < 16; i++) {
        uint16_t e = f2bf16_rne(in[32 + i]);
        if (out[16 + i] != e) {
            printf("ne2 low[%d]: got %04x want %04x\n", i, out[16 + i], e);
            return 1;
        }
        e = f2bf16_rne(in[16 + i]);
        if (out[32 + i] != e) {
            printf("ne2 high[%d]: got %04x want %04x\n", i, out[32 + i], e);
            return 1;
        }
    }
    printf("bf16 ok\n");
    return 0;
}
