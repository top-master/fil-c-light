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
    for (i = 0; i < 16; ++i) {
        uint16x8x2_t r = vld2q_dup_u16((uint16_t*)(buf + 2 * i));
        uint16_t a, b;
        __builtin_memcpy(&a, buf + 2 * i, 2);
        __builtin_memcpy(&b, buf + 2 * i + 2, 2);
        ZASSERT(r.val[0][0] == a);
        ZASSERT(r.val[1][0] == b);
    }
    uint8x16x2_t lane_in;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            lane_in.val[k][j] = (unsigned char)(10 + k * 10 + j);
    for (i = 0; i + 1 < 16; ++i) {
        uint8x16x2_t q = vld2q_lane_u8(buf + 2 * i, lane_in, 5);
        ZASSERT(q.val[0][5] == buf[2 * i]);
        ZASSERT(q.val[1][5] == buf[2 * i + 1]);
        ZASSERT(q.val[0][0] == (unsigned char)10);
        ZASSERT(q.val[1][15] == (unsigned char)35);
    }
    zprintf("neon loop ld2r moving test passed!\n");
    return 0;
}
