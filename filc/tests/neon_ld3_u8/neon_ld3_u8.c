#include <arm_neon.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdfil.h>
#include "utils.h"

int main(void)
{
    unsigned char* buf = opaque(malloc(48));
    unsigned char* buf2 = opaque(malloc(24));
    unsigned i;
    unsigned k;
    for (i = 0; i < 48; ++i)
        buf[i] = (unsigned char)(i * 7 + 3);
    for (i = 0; i < 24; ++i)
        buf2[i] = (unsigned char)(i * 11 + 5);
    uint8x16x3_t r = vld3q_u8(buf);
    for (i = 0; i < 16; ++i) {
        for (k = 0; k < 3; ++k)
            ZASSERT(r.val[k][i] == buf[3 * i + k]);
    }
    uint8x8x3_t r2 = vld3_u8(buf2);
    for (i = 0; i < 8; ++i) {
        for (k = 0; k < 3; ++k)
            ZASSERT(r2.val[k][i] == buf2[3 * i + k]);
    }
    zprintf("neon ld3 u8 test passed!\n");

    return 0;
}
