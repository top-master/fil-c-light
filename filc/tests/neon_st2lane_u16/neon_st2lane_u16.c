#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(12));
    unsigned i;
    for (i = 0; i < 12; ++i)
        buf[i] = (unsigned char)0xAA;
    uint16x8x2_t pair;
    pair.val[0] = vdupq_n_u16(0x1234);
    pair.val[1] = vdupq_n_u16(0x5678);
    vst2q_lane_u16((uint16_t*)buf, pair, 3);
    ZASSERT(((uint16_t*)buf)[0] == 0x1234);
    ZASSERT(((uint16_t*)buf)[1] == 0x5678);
    for (i = 4; i < 12; ++i)
        ZASSERT(buf[i] == (unsigned char)0xAA);
    zprintf("neon st2lane u16 test passed!\n");

    return 0;
}
