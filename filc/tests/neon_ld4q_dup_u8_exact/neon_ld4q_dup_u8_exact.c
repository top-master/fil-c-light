#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    /* Exact-fit 4-byte allocation: the replicate load touches exactly 4 bytes. */
    unsigned char* buf = opaque(malloc(4));
    unsigned i;
    for (i = 0; i < 4; ++i)
        buf[i] = (unsigned char)(i * 60 + 10);
    uint8x16x4_t r = vld4q_dup_u8(buf);
    unsigned j;
    for (j = 0; j < 16; ++j) {
        ZASSERT(r.val[0][j] == buf[0]);
        ZASSERT(r.val[1][j] == buf[1]);
        ZASSERT(r.val[2][j] == buf[2]);
        ZASSERT(r.val[3][j] == buf[3]);
    }
    zprintf("neon ld4q dup u8 exact test passed!\n");
    return 0;
}
