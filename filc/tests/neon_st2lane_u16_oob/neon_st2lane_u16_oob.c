#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    unsigned i;
    for (i = 0; i < 16; ++i)
        buf[i] = (unsigned char)0xAA;
    uint16x8x2_t pair;
    pair.val[0] = vdupq_n_u16(0x1234);
    pair.val[1] = vdupq_n_u16(0x5678);
    vst2q_lane_u16((uint16_t*)(buf + 13), pair, 0);
    ZASSERT(buf[13] == 0x34);

    zprintf("Should have failed!\n");
    return 0;
}
