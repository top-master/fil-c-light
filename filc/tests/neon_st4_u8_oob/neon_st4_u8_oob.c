#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned char tmp0[16];
    unsigned char tmp1[16];
    unsigned char tmp2[16];
    unsigned char tmp3[16];
    unsigned i;
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
    vst4q_u8(buf, quad);
    ZASSERT(buf[0] == 0);

    zprintf("Should have failed!\n");
    return 0;
}
