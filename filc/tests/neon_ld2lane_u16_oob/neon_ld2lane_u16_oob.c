#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    unsigned k;
    for (k = 0; k < 8; ++k)
        ((uint16_t*)buf)[k] = (uint16_t)(k * 4369 + 7);
    uint16x8x2_t src;
    src.val[0] = vdupq_n_u16(0x9999);
    src.val[1] = vdupq_n_u16(0x9999);
    uint16x8x2_t r = vld2q_lane_u16((uint16_t*)(buf + 13), src, 0);
    ZASSERT(r.val[0][0] == 0x1234);

    zprintf("Should have failed!\n");
    return 0;
}
