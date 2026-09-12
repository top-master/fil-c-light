#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(32));
    unsigned char tmp0[16];
    unsigned char tmp1[16];
    unsigned char tmp2[16];
    unsigned i;
    for (i = 0; i < 16; ++i) {
        tmp0[i] = (unsigned char)i;
        tmp1[i] = (unsigned char)(0x40 + i);
        tmp2[i] = (unsigned char)(0x80 + i);
    }
    uint8x16x3_t triple;
    triple.val[0] = vld1q_u8(tmp0);
    triple.val[1] = vld1q_u8(tmp1);
    triple.val[2] = vld1q_u8(tmp2);
    vst3q_u8(buf, triple);
    ZASSERT(buf[0] == 0);

    zprintf("Should have failed!\n");
    return 0;
}
