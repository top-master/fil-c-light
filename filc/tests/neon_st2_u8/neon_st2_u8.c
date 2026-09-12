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
    unsigned i;
    for (i = 0; i < 16; ++i) {
        tmp0[i] = (unsigned char)i;
        tmp1[i] = (unsigned char)(0x80 + i);
    }
    uint8x16x2_t pair;
    pair.val[0] = vld1q_u8(tmp0);
    pair.val[1] = vld1q_u8(tmp1);
    vst2q_u8(buf, pair);
    for (i = 0; i < 16; ++i) {
        ZASSERT(buf[2 * i] == (unsigned char)i);
        ZASSERT(buf[2 * i + 1] == (unsigned char)(0x80 + i));
    }
    zprintf("neon st2 u8 test passed!\n");

    return 0;
}
