#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i;
    for (i = 0; i < 16; ++i)
        ((uint16_t*)buf)[i] = (uint16_t)(i * 131 + 7);
    for (i = 0; i < 8; ++i)
        ((uint32_t*)(buf + 32))[i] = (uint32_t)(i * 100003 + 17);
    uint16x8x2_t r = vld2q_u16((uint16_t*)buf);
    for (i = 0; i < 8; ++i) {
        ZASSERT(r.val[0][i] == ((uint16_t*)buf)[2 * i]);
        ZASSERT(r.val[1][i] == ((uint16_t*)buf)[2 * i + 1]);
    }
    uint32x4x2_t r2 = vld2q_u32((uint32_t*)(buf + 32));
    for (i = 0; i < 4; ++i) {
        ZASSERT(r2.val[0][i] == ((uint32_t*)(buf + 32))[2 * i]);
        ZASSERT(r2.val[1][i] == ((uint32_t*)(buf + 32))[2 * i + 1]);
    }
    zprintf("neon ld2 u16 u32 test passed!\n");

    return 0;
}
