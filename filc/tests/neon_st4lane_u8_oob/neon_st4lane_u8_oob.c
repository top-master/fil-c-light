#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    unsigned k;
    for (k = 0; k < 16; ++k)
        buf[k] = (unsigned char)0x99;
    uint8x8x4_t src;
    for (k = 0; k < 4; ++k)
        src.val[k] = vdup_n_u8((unsigned char)(0x10 * (k + 1) + 0x22));
    vst4_lane_u8(buf + 13, src, 5);
    ZASSERT(buf[13] == 0x11);

    zprintf("Should have failed!\n");
    return 0;
}
