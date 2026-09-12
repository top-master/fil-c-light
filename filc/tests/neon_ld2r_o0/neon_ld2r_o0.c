#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i;
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x8x2_t r = vld2_dup_u8(buf + 40);
    unsigned j;
    for (j = 0; j < 8; ++j) {
        ZASSERT(r.val[0][j] == buf[40]);
        ZASSERT(r.val[1][j] == buf[41]);
    }
    int16x8x2_t q = vld2q_dup_s16((int16_t*)(buf + 16));
    for (j = 0; j < 8; ++j) {
        ZASSERT(q.val[0][j] == (int16_t)(unsigned short)(buf[16] | (buf[17] << 8)));
        ZASSERT(q.val[1][j] == (int16_t)(unsigned short)(buf[18] | (buf[19] << 8)));
    }
    zprintf("neon ld2r o0 test passed!\n");
    return 0;
}
