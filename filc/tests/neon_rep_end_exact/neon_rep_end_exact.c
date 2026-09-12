#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(32));
    unsigned i;
    for (i = 0; i < 32; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    /* Replicate load touching exactly buf[29], buf[30], buf[31]. */
    uint8x16x3_t r = vld3q_dup_u8(buf + 29);
    unsigned j;
    for (j = 0; j < 16; ++j) {
        ZASSERT(r.val[0][j] == buf[29]);
        ZASSERT(r.val[1][j] == buf[30]);
        ZASSERT(r.val[2][j] == buf[31]);
    }
    /* Lane load touching exactly buf[30], buf[31]. */
    uint8x16x2_t x;
    for (j = 0; j < 16; ++j) {
        x.val[0][j] = 111;
        x.val[1][j] = 222;
    }
    uint8x16x2_t q = vld2q_lane_u8(buf + 30, x, 15);
    for (j = 0; j < 16; ++j) {
        ZASSERT(q.val[0][j] == (j == 15 ? buf[30] : 111));
        ZASSERT(q.val[1][j] == (j == 15 ? buf[31] : 222));
    }
    zprintf("neon rep end exact test passed!\n");
    return 0;
}
