#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(8));
    unsigned k;
    for (k = 0; k < 8; ++k)
        buf[k] = (unsigned char)0x99;
    uint8x8x4_t src;
    for (k = 0; k < 4; ++k)
        src.val[k] = vdup_n_u8((unsigned char)(0x10 * (k + 1) + 0x22));
    vst4_lane_u8(buf, src, 5);
    for (k = 0; k < 4; ++k)
        ZASSERT(buf[k] == vget_lane_u8(src.val[k], 5));
    for (k = 4; k < 8; ++k)
        ZASSERT(buf[k] == (unsigned char)0x99);
    zprintf("neon st4lane u8 test passed!\n");

    return 0;
}
