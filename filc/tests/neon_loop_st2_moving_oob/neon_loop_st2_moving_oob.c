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
        buf[i] = (unsigned char)(i * 7 + 11);
    uint16x8x2_t x;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 8; ++j)
            x.val[k][j] = (uint16_t)(k * 10 + j + 1);
    /* Overruns on the last iteration: 62 + 4 > 64. */
    for (i = 0; i < 32; ++i)
        vst2q_lane_u16((uint16_t*)(buf + 2 * i), x, 0);
    zprintf("Should have failed!\n");
    return 0;
}
