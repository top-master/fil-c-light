#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    /* Exact-fit 4-byte allocation: the replicate load touches exactly 4 bytes. */
    unsigned char* buf = opaque(malloc(4));
    buf[0] = 0x21;
    buf[1] = 0x43;
    buf[2] = 0x65;
    buf[3] = 0x87;
    int16x8x2_t r = vld2q_dup_s16((int16_t*)buf);
    unsigned j;
    for (j = 0; j < 8; ++j) {
        ZASSERT(r.val[0][j] == (int16_t)0x4321);
        ZASSERT(r.val[1][j] == (int16_t)(int16_t)0x8765);
    }
    zprintf("neon ld2q dup s16 exact test passed!\n");
    return 0;
}
