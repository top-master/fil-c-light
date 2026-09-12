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
    uint32x4x4_t x;
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 4; ++j)
            x.val[k][j] = (uint32_t)(k * 1000 + j + 1);
    /* Lane 0: touches exactly 4 * 4 = 16 bytes at buf. */
    vst4q_lane_u32((uint32_t*)buf, x, 0);
    for (k = 0; k < 4; ++k)
        ZASSERT(*(uint32_t*)(void*)(buf + 4 * k) == (uint32_t)(k * 1000 + 1));
    /* Everything else untouched so far. */
    for (i = 16; i < 64; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    /* Lane 3: touches exactly 16 bytes at buf + 32. */
    vst4q_lane_u32((uint32_t*)buf + 8, x, 3);
    for (k = 0; k < 4; ++k)
        ZASSERT(*(uint32_t*)(void*)(buf + 32 + 4 * k) == (uint32_t)(k * 1000 + 4));
    for (i = 16; i < 32; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    for (i = 48; i < 64; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    /* Non-target lanes retain their pass-through values. */
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 4; ++j)
            ZASSERT(x.val[k][j] == (uint32_t)(k * 1000 + j + 1));
    zprintf("neon st4q lane u32 test passed!\n");
    return 0;
}
