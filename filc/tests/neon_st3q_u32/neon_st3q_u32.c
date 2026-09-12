#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(96));
    unsigned i, k, j;
    for (i = 0; i < 96; ++i)
        buf[i] = (unsigned char)(i * 13 + 7);
    uint32x4x3_t x;
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 4; ++j)
            x.val[k][j] = (uint32_t)(k * 100000 + j + 1);
    vst3q_u32((uint32_t*)buf, x);
    /* Interleave: element (3 * j + k) gets x.val[k][j]. */
    for (k = 0; k < 3; ++k)
        for (j = 0; j < 4; ++j)
            ZASSERT(*(uint32_t*)(void*)(buf + 4 * (3 * j + k)) == (uint32_t)(k * 100000 + j + 1));
    for (i = 48; i < 96; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 13 + 7));
    zprintf("neon st3q u32 test passed!\n");
    return 0;
}
