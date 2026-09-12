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
        buf[i] = (unsigned char)(i * 7 + 3);
    uint8x16x2_t x;
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            x.val[k][j] = (unsigned char)(k * 10 + j + 1);
    vst1q_u8_x2(buf + 32, x);
    for (i = 0; i < 32; ++i)
        ZASSERT(buf[i] == (unsigned char)(i * 7 + 3));
    for (k = 0; k < 2; ++k)
        for (j = 0; j < 16; ++j)
            ZASSERT(buf[32 + 16 * k + j] == (unsigned char)(k * 10 + j + 1));
    zprintf("neon st1x2 o0 test passed!\n");
    return 0;
}
