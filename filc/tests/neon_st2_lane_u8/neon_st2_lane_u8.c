#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i, k, j;
    for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 13 + 7);
    uint8x8x2_t x;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 8; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    /* Lane 0 on 64-bit registers: touches exactly 2 bytes. */
    vst2_lane_u8(buf + 8, x, 0);
    ZASSERT(buf[8] == 1);
    ZASSERT(buf[9] == 11);
    for (i = 0; i < 8; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    for (i = 10; i < 64; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    /* Lane 7: touches exactly 2 bytes at buf + 30. */
    vst2_lane_u8(buf + 30, x, 7);
    ZASSERT(buf[30] == 8);
    ZASSERT(buf[31] == 18);
    for (i = 10; i < 30; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    for (i = 32; i < 64; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    zprintf("neon st2 lane u8 test passed!\n");
    return 0;
}
