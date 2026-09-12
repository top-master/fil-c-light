#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(4));
    unsigned i;
    ((uint16_t*)buf)[0] = 0x1234;
    ((uint16_t*)buf)[1] = 0x5678;
    uint16x8x2_t src;
    src.val[0] = vdupq_n_u16(0x1122);
    src.val[1] = vdupq_n_u16(0x3344);
    uint16x8x2_t r = vld2q_lane_u16((uint16_t*)buf, src, 5);
    for (i = 0; i < 8; ++i) {
        if (i == 5) {
            ZASSERT(r.val[0][i] == 0x1234);
            ZASSERT(r.val[1][i] == 0x5678);
        } else {
            ZASSERT(r.val[0][i] == 0x1122);
            ZASSERT(r.val[1][i] == 0x3344);
        }
    }
    zprintf("neon ld2lane u16 test passed!\n");

    return 0;
}
