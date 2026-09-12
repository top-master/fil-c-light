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
        buf[i] = (unsigned char)(i * 13 + 7);
    uint32x4x2_t x;
    unsigned k, j;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 4; ++j)
            x.val[k][j] = (uint32_t)(k * 1000 + j + 1);
    /* Lane 0. */
    uint32x4x2_t r0 = vld2q_lane_u32((uint32_t*)buf, x, 0);
    ZASSERT(r0.val[0][0] == *(uint32_t*)(void*)buf);
    ZASSERT(r0.val[1][0] == *(uint32_t*)(void*)(buf + 4));
    for (j = 1; j < 4; ++j) {
        ZASSERT(r0.val[0][j] == (uint32_t)(0 * 1000 + j + 1));
        ZASSERT(r0.val[1][j] == (uint32_t)(1 * 1000 + j + 1));
    }
    /* Lane 3. */
    uint32x4x2_t r3 = vld2q_lane_u32((uint32_t*)buf + 8, x, 3);
    ZASSERT(r3.val[0][3] == *(uint32_t*)(void*)(buf + 32));
    ZASSERT(r3.val[1][3] == *(uint32_t*)(void*)(buf + 36));
    for (j = 0; j < 3; ++j) {
        ZASSERT(r3.val[0][j] == (uint32_t)(0 * 1000 + j + 1));
        ZASSERT(r3.val[1][j] == (uint32_t)(1 * 1000 + j + 1));
    }
    zprintf("neon ld2q lane u32 test passed!\n");
    return 0;
}
