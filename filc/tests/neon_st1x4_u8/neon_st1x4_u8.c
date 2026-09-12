#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned char tmp0[16];
    unsigned char tmp1[16];
    unsigned char tmp2[16];
    unsigned char tmp3[16];
    unsigned i;
    unsigned k;
    for (i = 0; i < 16; ++i) {
        tmp0[i] = (unsigned char)i;
        tmp1[i] = (unsigned char)(0x40 + i);
        tmp2[i] = (unsigned char)(0x80 + i);
        tmp3[i] = (unsigned char)(0xc0 + i);
    }
    uint8x16x4_t quad;
    quad.val[0] = vld1q_u8(tmp0);
    quad.val[1] = vld1q_u8(tmp1);
    quad.val[2] = vld1q_u8(tmp2);
    quad.val[3] = vld1q_u8(tmp3);
    vst1q_u8_x4(buf, quad);
    for (i = 0; i < 16; ++i) {
        for (k = 0; k < 4; ++k)
            ZASSERT(buf[16 * k + i] == (unsigned char)(0x40 * k + i));
    }
    zprintf("neon st1x4 u8 test passed!\n");

    return 0;
}
