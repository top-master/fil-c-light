#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(16));
    unsigned i;
    unsigned k;
    for (i = 0; i < 4; ++i)
        ((uint32_t*)buf)[i] = (uint32_t)(0x10000 * (i + 1) + 0x99);
    uint32x4x4_t src;
    for (k = 0; k < 4; ++k)
        src.val[k] = vdupq_n_u32((uint32_t)(0x1000 * (k + 1) + 0x77));
    uint32x4x4_t r = vld4q_lane_u32((uint32_t*)buf, src, 1);
    for (i = 0; i < 4; ++i) {
        for (k = 0; k < 4; ++k) {
            if (i == 1)
                ZASSERT(r.val[k][i] == ((uint32_t*)buf)[k]);
            else
                ZASSERT(r.val[k][i] == (uint32_t)(0x1000 * (k + 1) + 0x77));
        }
    }
    zprintf("neon ld4lane u32 test passed!\n");

    return 0;
}
