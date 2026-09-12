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
    uint8x8x4_t x;
    unsigned k, j;
    for (k = 0; k < 4; ++k)
        for (j = 0; j < 8; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    /* 8 + 32 bytes exceeds the 32-byte global. */
    vst4_u8(gbuf + 8, x);
    zprintf("Should have failed!\n");
    return 0;
}
