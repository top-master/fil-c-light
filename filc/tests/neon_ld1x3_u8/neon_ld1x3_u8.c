#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned i;
    unsigned k;
        for (i = 0; i < 48; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x3_t r = vld1q_u8_x3(buf);
    for (i = 0; i < 16; ++i) {
        for (k = 0; k < 3; ++k)
            ZASSERT(r.val[k][i] == buf[16 * k + i]);
    }
    zprintf("neon ld1x3 u8 test passed!\n");

    return 0;
}
