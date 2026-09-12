#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned i;
        for (i = 0; i < 48; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x2_t r = vld2q_u8(buf);
    for (i = 0; i < 16; ++i) {
        ZASSERT(r.val[0][i] == buf[2 * i]);
        ZASSERT(r.val[1][i] == buf[2 * i + 1]);
    }
    uint8x8x2_t r2 = vld2_u8(buf + 32);
    for (i = 0; i < 8; ++i) {
        ZASSERT(r2.val[0][i] == buf[32 + 2 * i]);
        ZASSERT(r2.val[1][i] == buf[32 + 2 * i + 1]);
    }
    zprintf("neon ld2 u8 test passed!\n");

    return 0;
}
