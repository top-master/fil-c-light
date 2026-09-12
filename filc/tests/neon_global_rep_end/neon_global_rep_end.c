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
    /* Exact-end replicate load: touches only gbuf[30] and gbuf[31]. */
    uint8x16x2_t r = vld2q_dup_u8(gbuf + 30);
    unsigned j;
    for (j = 0; j < 16; ++j) {
        ZASSERT(r.val[0][j] == gbuf[30]);
        ZASSERT(r.val[1][j] == gbuf[31]);
    }
    /* Exact-end lane load: touches only gbuf[30] and gbuf[31]. */
    uint8x16x2_t x;
    for (j = 0; j < 16; ++j) {
        x.val[0][j] = 100;
        x.val[1][j] = 200;
    }
    uint8x16x2_t q = vld2q_lane_u8(gbuf + 30, x, 0);
    for (j = 0; j < 16; ++j) {
        ZASSERT(q.val[0][j] == (j == 0 ? gbuf[30] : 100));
        ZASSERT(q.val[1][j] == (j == 0 ? gbuf[31] : 200));
    }
    zprintf("neon global rep end test passed!\n");
    return 0;
}
