#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

unsigned char gbuf[32];

static void gfill(void)
{
    unsigned i;
    for (i = 0; i < 32; ++i)
        gbuf[i] = (unsigned char)(i * 13 + 5);
}

int main(void)
{
    gfill();
    uint8x16x2_t r = vld1q_u8_x2(gbuf);
    unsigned i;
    for (i = 0; i < 16; ++i)
        ZASSERT(r.val[0][i] == gbuf[i]);
    for (i = 0; i < 16; ++i)
        ZASSERT(r.val[1][i] == gbuf[16 + i]);
    zprintf("neon global ld1x2 test passed!\n");
    return 0;
}
