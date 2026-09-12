#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(33));
    unsigned i;
        for (i = 0; i < 33; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x2_t r = vld2q_u8(buf + 1);
    for (i = 0; i < 16; ++i) {
        ZASSERT(r.val[0][i] == buf[1 + 2 * i]);
        ZASSERT(r.val[1][i] == buf[2 + 2 * i]);
    }
    zprintf("neon ld2 misaligned exact test passed!\n");

    return 0;
}
