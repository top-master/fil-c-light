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
    uint16x8x3_t x;
    unsigned k, j;
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 8; ++j)
            x.val[k][j] = (uint16_t)(k * 100 + j + 1);
    /* Touches exactly 3 * 2 = 6 bytes at buf + 16. */
    uint16x8x3_t r = vld3q_lane_u16((uint16_t*)(buf + 16), x, 7);
    for (k = 0; k < 3; ++k) {
        uint16_t e;
        __builtin_memcpy(&e, buf + 16 + 2 * k, 2);
        ZASSERT(r.val[k][7] == e);
    }
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 7; ++j)
            ZASSERT(r.val[k][j] == (uint16_t)(k * 100 + j + 1));
    zprintf("neon ld3q lane u16 l7 test passed!\n");
    return 0;
}
