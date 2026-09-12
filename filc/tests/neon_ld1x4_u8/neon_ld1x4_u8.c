#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(64));
    unsigned i;
    unsigned k;
        for (i = 0; i < 64; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x4_t r = vld1q_u8_x4(buf);
    for (i = 0; i < 16; ++i) {
        for (k = 0; k < 4; ++k)
            ZASSERT(r.val[k][i] == buf[16 * k + i]);
    }
    zprintf("neon ld1x4 u8 test passed!\n");

    return 0;
}
